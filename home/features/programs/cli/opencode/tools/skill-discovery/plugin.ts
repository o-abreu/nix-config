// INFO: Runtime skill discovery for arbitrary git repositories.
//
// `pkgs.skills` (github:vercel-labs/skills) does the fetching, auth and lockfile
// bookkeeping. This plugin only adds the glue that makes it usable from inside a
// session:
//
//   * `skills_discover` lists what a repository offers, without installing.
//   * `skills_install` / `skills_remove` stage or drop a skill.
//   * Every staged skill is registered through `ctx.skill.transform`, so a new
//     skill is usable in the same session instead of after a restart.
//
// Two deliberate properties:
//
//   1. Installs are project-scoped into STAGING, which is *not* one of the
//      directories OpenCode discovers skills from. A discovered skill therefore
//      can never be picked up by native discovery and advertised before review.
//   2. Registered skills get `autoinvoke: false`, so they stay hidden from the
//      model's available list and can only be loaded by exact ID.
//
// An ID that already exists from another source (a Nix-managed skill) is left
// untouched, so a discovered skill can never shadow a trusted one.
import { Plugin, Skill } from "@opencode/plugin";
import { spawn } from "node:child_process";
import { existsSync, mkdirSync, readdirSync, readFileSync } from "node:fs";
import { homedir } from "node:os";
import { join } from "node:path";

const STAGING = join(homedir(), ".local", "share", "opencode", "skill-discovery");
const LOCKFILE = join(STAGING, "skills-lock.json");
const INSTALL_ROOT = join(STAGING, ".agents", "skills");
const SKILL_FILE = "SKILL.md";

// The editor shape is owned by OpenCode's plugin SDK; there is no local type
// package to import it from.
type Editor = any;

type LockEntry = {
  source?: string;
  sourceType?: string;
  skillPath?: string;
  computedHash?: string;
};

type Listing = { name: string; description: string };

const ANSI = /\u001b\[[0-9;?]*[a-zA-Z]/g;

const strip = (text: string) => text.replace(ANSI, "").replace(/\r/g, "\n");

const toId = (name: string) =>
  name
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "")
    .slice(0, 64);

function readLock(): Record<string, LockEntry> {
  try {
    return JSON.parse(readFileSync(LOCKFILE, "utf8"))?.skills ?? {};
  } catch {
    return {};
  }
}

function parseFrontmatter(text: string) {
  const match = text.match(/^---\r?\n([\s\S]*?)\r?\n---\r?\n?/);
  if (!match) return { content: text } as { name?: string; description?: string; content: string };

  const fields: Record<string, string> = {};
  const lines = match[1].split(/\r?\n/);

  for (let i = 0; i < lines.length; i++) {
    const kv = lines[i].match(/^([A-Za-z0-9_-]+):\s*(.*)$/);
    if (!kv) continue;
    const key = kv[1];
    const value = kv[2].trim();

    if (value === ">" || value === "|" || value === ">-" || value === "|-") {
      const buffer: string[] = [];
      for (let j = i + 1; j < lines.length; j++) {
        if (!/^\s+\S/.test(lines[j])) break;
        buffer.push(lines[j].trim());
        i = j;
      }
      fields[key] = value.startsWith(">") ? buffer.join(" ") : buffer.join("\n");
      continue;
    }

    fields[key] = value.replace(/^["'](.*)["']$/, "$1");
  }

  return {
    name: fields.name,
    description: fields.description,
    content: text.slice(match[0].length),
  };
}

function locate(id: string): string | undefined {
  const direct = join(INSTALL_ROOT, id, SKILL_FILE);
  if (existsSync(direct)) return direct;

  if (!existsSync(INSTALL_ROOT)) return undefined;
  for (const entry of readdirSync(INSTALL_ROOT, { withFileTypes: true })) {
    if (!entry.isDirectory()) continue;
    const candidate = join(INSTALL_ROOT, entry.name, SKILL_FILE);
    if (!existsSync(candidate)) continue;
    try {
      const { name } = parseFrontmatter(readFileSync(candidate, "utf8"));
      if (name === id) return candidate;
    } catch {
      // Unreadable candidate: keep looking.
    }
  }
  return undefined;
}

function readSkill(id: string) {
  const file = locate(id);
  if (!file) return undefined;
  const { name, description, content } = parseFrontmatter(readFileSync(file, "utf8"));
  return { file, name: name ?? id, description: description ?? "", content };
}

// `skills add --list` only renders a box-drawn table; there is no --json flag.
function parseListing(output: string): Listing[] {
  const items: Listing[] = [];

  for (const line of strip(output).split("\n")) {
    const head = line.match(/^\s*│ {4}(\S+)\s*$/);
    if (head && !head[1].startsWith("─")) {
      items.push({ name: head[1], description: "" });
      continue;
    }
    const body = line.match(/^\s*│ {6,}(\S.*)$/);
    if (body && items.length > 0) {
      const last = items[items.length - 1];
      last.description = last.description ? `${last.description} ${body[1].trim()}` : body[1].trim();
    }
  }

  return items;
}

function run(args: string[], signal?: AbortSignal) {
  return new Promise<{ code: number; stdout: string; stderr: string }>((resolve) => {
    const child = spawn("skills", args, {
      cwd: STAGING,
      env: { ...process.env, NO_COLOR: "1", FORCE_COLOR: "0" },
      signal,
      stdio: ["ignore", "pipe", "pipe"],
    });

    let stdout = "";
    let stderr = "";
    child.stdout?.on("data", (chunk) => (stdout += String(chunk)));
    child.stderr?.on("data", (chunk) => (stderr += String(chunk)));
    child.on("error", (error) => resolve({ code: -1, stdout, stderr: `${stderr}${error}` }));
    child.on("close", (code) => resolve({ code: code ?? -1, stdout, stderr }));
  });
}

const failure = (r: { code: number; stdout: string; stderr: string }) =>
  `skills exited ${r.code}\n${strip(r.stderr || r.stdout).trim().split("\n").slice(-12).join("\n")}`;

export default Plugin.define({
  id: "skill-discovery",
  setup(ctx) {
    mkdirSync(STAGING, { recursive: true });

    const sync = (editor: Editor) => {
      for (const id of Object.keys(readLock())) {
        const skill = readSkill(id);
        if (!skill) continue;

        const skillId = toId(id);
        const existing = editor.get(skillId);
        // Keep whatever a Nix-managed source already registered.
        if (existing?.path && !String(existing.path).startsWith(INSTALL_ROOT)) continue;

        if (existing) editor.remove(skillId);
        editor.add({
          id: Skill.ID.make(skillId),
          name: Skill.Name.make(skill.name),
          description: skill.description,
          path: Skill.Info.fields.path.make(skill.file),
          content: skill.content,
          autoinvoke: false,
        });
      }
    };

    void ctx.skill.transform(sync);

    void ctx.tool.transform((editor: Editor) => {
      editor.namespace({
        name: "skills",
        description:
          "Discover and install agent skills from git repositories. " +
          "Anything staged through these tools is unvetted third-party content.",
      });

      editor.add({
        name: "discover",
        description:
          "List the agent skills offered by a git repository without installing anything. " +
          "Accepts GitHub shorthand (owner/repo), any git URL, or a URL to a subdirectory. " +
          "Omit `source` to list skills already staged in this session. " +
          "For ecosystem-wide search instead of one repository, use the `find-skills` skill (`skills find`).",
        input: {
          type: "object",
          properties: {
            source: {
              type: "string",
              description:
                "Repository, e.g. 'vercel-labs/agent-skills', 'https://gitlab.com/org/repo', or 'https://github.com/owner/repo/tree/main/skills/foo'.",
            },
          },
          additionalProperties: false,
        },
        execute: async (input: { source?: string }, context: { signal?: AbortSignal }) => {
          const lock = readLock();

          if (!input.source) {
            const staged = Object.entries(lock).map(([id, entry]) => ({
              id: toId(id),
              source: entry.source,
              file: locate(id),
            }));
            return {
              content:
                staged.length === 0
                  ? "No discovered skills are staged."
                  : JSON.stringify(staged, null, 2),
            };
          }

          const result = await run(["add", input.source, "--list", "-y"], context.signal);
          if (result.code !== 0) return { content: failure(result) };

          const available = parseListing(result.stdout);
          if (available.length === 0)
            return { content: `No skills found.\n\n${strip(result.stdout).trim().slice(-2000)}` };

          return {
            content: JSON.stringify(
              {
                source: input.source,
                staged: Object.keys(lock).map(toId),
                available,
              },
              null,
              2,
            ),
          };
        },
      });

      editor.add({
        name: "install",
        description:
          "Install one skill from a repository into the private staging area. " +
          "The skill is registered but hidden (`autoinvoke` off): load it by exact ID. " +
          "Requires explicit user approval for both the skill and its source; never batch-install a repository. " +
          "Never install with `-g` into ~/.agents/skills: OpenCode scans that directory natively and would " +
          "advertise the skill before review. A skill whose ID matches a Nix-managed skill is ignored " +
          "rather than allowed to shadow it.",
        input: {
          type: "object",
          properties: {
            source: {
              type: "string",
              description: "Repository the skill comes from (same formats as `skills_discover`).",
            },
            skill: {
              type: "string",
              description: "Exact skill name as reported by `skills_discover`.",
            },
          },
          required: ["source", "skill"],
          additionalProperties: false,
        },
        execute: async (
          input: { source: string; skill: string },
          context: { signal?: AbortSignal },
        ) => {
          const result = await run(
            ["add", input.source, "--skill", input.skill, "--copy", "-y", "-a", "opencode"],
            context.signal,
          );
          if (result.code !== 0) return { content: failure(result) };

          const id = Object.keys(readLock()).find(
            (key) => key === input.skill || toId(key) === toId(input.skill),
          );
          if (!id)
            return {
              content: `Install reported success but '${input.skill}' is not in the lockfile.\n\n${strip(result.stdout).trim().slice(-1500)}`,
            };

          await ctx.skill.reload();

          const skill = readSkill(id);
          return {
            content: [
              `Installed '${id}' from ${input.source} into the staging area.`,
              `Path: ${skill?.file ?? locate(id) ?? "unknown"}`,
              "",
              "Registered with autoinvoke disabled, so it is not advertised to the model.",
              `Load it explicitly with the skill tool using id "${toId(id)}", or by mentioning @${toId(id)}.`,
              "",
              "Read the file before using it if it has not been reviewed yet.",
            ].join("\n"),
          };
        },
      });

      editor.add({
        name: "remove",
        description:
          "Remove a previously discovered skill from the staging area. " +
          "Prefer this over keeping a staged copy once a skill proves its worth: promote it to a flake " +
          "input installed through `xdg.configFile`, the way `tools/pdf.nix` and `tools/asta/default.nix` do.",
        input: {
          type: "object",
          properties: {
            skill: { type: "string", description: "Skill ID to remove." },
          },
          required: ["skill"],
          additionalProperties: false,
        },
        execute: async (input: { skill: string }, context: { signal?: AbortSignal }) => {
          const result = await run(["remove", input.skill, "-y"], context.signal);
          if (result.code !== 0) return { content: failure(result) };
          await ctx.skill.reload();
          return { content: `Removed '${input.skill}'.` };
        },
      });
    });
  },
});
