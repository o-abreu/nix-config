# INFO: Terminal keymap factory.
#
# This file is a Nix function that turns a toggle specification into a single
# Lua function (`__raw`), which nixvim installs as a keymap's action. Callers
# are `default.nix`, `_layouts.nix` in this directory, the `integrations/`
# modules (lazygit, btop, REPLs) and the opencode keymaps: `default.nix` binds
# `<C-t>` plus the float / vertical / horizontal shell layouts, `_layouts.nix`
# expands a shared prefix into exactly those layouts, and the others build
# single-purpose toggles from the same factory.
#
# Every keypress runs the same `open()` logic, so the bindings know more than
# "spawn a terminal":
#
#   1. If the keypress happens *inside* the terminal this key owns, toggling
#      returns to the previous buffer instead of spawning anything.
#   2. A terminal is reused when it owns the same snacks slot (`count`) and
#      its cwd lives in the same project tree as the buffer the key was
#      pressed from. That is why shells/REPLs survive moving between files.
#   3. Otherwise a new terminal is spawned, with its working directory
#      seeded from the initiating buffer (so a REPL starts next to the file).
#   4. The resolved terminal is frozen into `_G.__last_term`, which is what
#      `<C-t>` ("toggle last terminal") replays from anywhere.
#   5. `listed` terminals (the ones visible in bufferline) swap buffers inside
#      the current window instead of opening a split, and remember the buffer
#      they displaced so toggling back works.
{
  config,
  lib,
  ...
}: {
  # The command the terminal runs: a string ("fish"), an argv table
  # (["julia", "--banner=no"]), or null for `vim.o.shell`.
  # Mutually exclusive with `resolve`, which defers the decision to keypress
  # time; when `resolve` is set, `bindSlime` is still honoured but `name`
  # must come from the resolved spec.
  cmd ? null,
  # Terminal options: `count` is the snacks slot id — it must be distinct per
  # tool (this config uses: lazygit 1, btop 2, float/split layouts 3, REPLs
  # 4-6, listed opencode buffer 8) — and `win.position` is how it is
  # displayed ("float", "right", "bottom", or "current" to replace the
  # current window's buffer instead of splitting).
  opts,
  # Bind vim-slime to the terminal it spawns: after opening, the *source*
  # buffer's `b:slime_config` is pointed at the terminal's pty (and never at
  # itself), so sending a cell/selection never prompts for a target.
  bindSlime ? false,
  # Make the terminal a regular, listed buffer — i.e. a real entry in
  # bufferline that toggling swaps into the current window — instead of an
  # unlisted overlay window.
  listed ? false,
  # Stable, readable buffer name. Neovim auto-names terminal buffers
  # `term://<cwd>//<pid>:<cmd>`, which is unreadable as a bufferline tab and
  # never matches the mini.icons filename entries (`file.fish`,
  # `file.Opencode`, ...). The name is applied as `term://<name>`:
  # bufferline shows the basename, and keeping the `term://` scheme stops
  # Neovim from resolving the buffer to a real file under the cwd.
  # Only use this on terminals that exist once per Neovim instance, since the
  # name must be unique (a collision makes the rename a no-op; see the Lua).
  name ? null,
  # Alternatively to `cmd`: a Lua *expression string* evaluated at keypress
  # time that must return `{ cmd = ..., count = ..., name? = ... }` or nil to
  # abort. Used by the REPL integrations, which pick the interpreter from the
  # buffer's language. When set, `cmd`/`opts.count` are ignored.
  resolve ? null,
}: let
  lua = config.lib.nixvim.lua;
  # The two parameters resolved at keypress time (`cmd`, `count`) are bound
  # as locals up front so the rest of the function is identical for both
  # sources. The `resolve` branch aborts early when the spec is incomplete:
  # e.g. no interpreter for the buffer's language was found.
  prelude =
    if resolve == null
    then ''
      local cmd = ${lua.toLuaObject cmd}
      local count = ${toString opts.count}
      local name = ${lua.toLuaObject name}
    ''
    else ''
      local spec = ${resolve}
      if spec == nil or spec.cmd == nil or spec.count == nil then
        return
      end
      local cmd = spec.cmd
      local count = spec.count
      local name = spec.name
    '';
in {
  __raw = with config.lib.nixvim.lua;
  # lua
    ''
      function()
        ${prelude}
        local position = ${lib.attrByPath ["win" "position"] null opts |> toLuaObject}
        local bind_slime = ${toLuaObject bindSlime}
        local listed = ${toLuaObject listed}

        -- Capture the buffer that initiated the launch: it is both the buffer
        -- vim-slime should send from and the buffer whose directory seeds a
        -- new terminal's working directory (step 3 below).
        local source_buf = vim.api.nvim_get_current_buf()
        local terminal = require("snacks.terminal")

        -- Point vim-slime at the given terminal by writing b:slime_config,
        -- so sending a cell/selection never prompts for a target. Never bind
        -- a terminal to itself.
        local function attach_slime(term)
          local tbuf = term and term.buf
          local jobid = tbuf and vim.b[tbuf].terminal_job_id
          if jobid and source_buf ~= tbuf then
            vim.b[source_buf].slime_config = {
              jobid = jobid,
              pid = vim.fn.jobpid(jobid),
            }
          end
        end

        -- Rename a terminal buffer to the stable `term://<name>` name, if the
        -- factory was given one. This cannot happen in `win.on_buf`: snacks
        -- spawns the job through `termopen` after building its buffer, and
        -- `termopen` assigns its own `term://<cwd>//<pid>:<cmd>` name to the
        -- buffer — overwriting whatever the buffer was called. Renaming after
        -- the terminal object exists is therefore the last word.
        --
        -- When `name` is set, bufferline displays the basename (`opencode`,
        -- `fish`, ...) and the same basename is what the mini.icons `file`
        -- category matches, so `file.Opencode` / `file.fish` provide the glyph.
        -- Keep the `term://` scheme: a scheme-less name would be resolved by
        -- Neovim to a real file path under the cwd. Names must be unique per
        -- Neovim instance; a collision (two project trees sharing the same
        -- slot) raises `E95: Buffer with this name already exists`, which the
        -- `pcall` turns into "keep the auto-generated name".
        local function set_term_name(term)
          if name and term and term.buf then
            pcall(vim.api.nvim_buf_set_name, term.buf, "term://" .. name)
          end
        end

        -- Freeze the resolved target so <C-t> replays this exact
        -- terminal, regardless of the buffer focused at the time.
        local function open(cwd, bind)
          local replay = {
            count = count,
            cwd = cwd,
          }
          if position then
            replay.win = { position = position }
          end

          if listed then
            replay.win = replay.win or {}
            -- Snacks creates this buffer as an unlisted scratch buffer. Make it
            -- a regular buffer so bufferline picks it up; this runs before the
            -- buffer is displayed, so the BufEnter that follows already sees
            -- the updated listing. (Buffer *naming* cannot happen here: it
            -- would be overwritten by `termopen` — see `set_term_name`.)
            replay.win.on_buf = function(self)
              vim.bo[self.buf].buflisted = true
            end
          end

          _G.__last_term = function()
            if not listed then
              -- Unlisted terminals are overlay windows: plain snacks toggle
              -- (spawn it if hidden, hide it if shown in place). `toggle`
              -- returns the terminal either way.
              set_term_name(terminal.toggle(cmd, replay))
              return
            end

            -- Listed terminals behave like buffers: get the terminal (or
            -- spawn it; `created` says which) and swap it into the current
            -- window instead of opening a split.
            local term, created = terminal.get(cmd, replay)
            if not term then
              return
            end
            set_term_name(term)
            local cur = vim.api.nvim_get_current_buf()
            if not created and cur == term.buf then
              -- Toggling from inside the terminal returns to the buffer that
              -- was showing before it, keeping the window open. `b#` is not
              -- enough: snacks swaps buffers with `nvim_win_set_buf`, which
              -- does not update the alternate buffer register.
              local prev = vim.b[term.buf].snacks_terminal_prev
              if prev and prev ~= term.buf and vim.api.nvim_buf_is_valid(prev) then
                vim.api.nvim_win_set_buf(0, prev)
              elseif not pcall(vim.cmd, "buffer #") then
                vim.cmd("enew")
              end
            else
              if cur ~= term.buf then
                -- Remember what was being shown, so the toggle-back branch
                -- can restore it.
                vim.b[term.buf].snacks_terminal_prev = cur
              elseif created then
                -- A freshly spawned terminal: the source buffer is what was
                -- under the cursor when the key was pressed.
                vim.b[term.buf].snacks_terminal_prev = source_buf
              end
              -- `show()` only focuses an already visible terminal and
              -- otherwise swaps it into the current window.
              term:show():focus()
            end

            -- `Snacks.win` installs a `BufWinEnter` handler that forces its
            -- buffer back into the window (see `fixbuf` in snacks' `win.lua`),
            -- which would undo every buffer switch away from the terminal.
            -- Drop just that handler; the group's other events stay intact.
            local ok, acs = pcall(vim.api.nvim_get_autocmds, {
              event = "BufWinEnter",
              group = "snacks_win_" .. tostring(term.id),
            })
            if ok then
              for _, ac in ipairs(acs) do
                pcall(vim.api.nvim_del_autocmd, ac.id)
              end
            end
          end
          _G.__last_term()

          if bind and bind_slime then
            attach_slime(terminal.get(cmd, replay))
          end
        end

        -- 1. Inside a matching terminal: toggle it, reusing its
        --    recorded cwd verbatim (never spawn a sibling).
        --    `b:snacks_terminal.cmd` is the raw command snacks ran, so an
        --    argv table matches only itself; `id` is the slot count.
        local cur = vim.b.snacks_terminal
        if cur and cur.cmd == cmd and cur.id == count then
          open(cur.cwd, false)
          return
        end

        -- 2. Seed the working directory from the current buffer,
        --    so REPLs (ipython, ...) start next to the file. Plain windows
        --    (dashboards, :terminal, ...) keep Neovim's cwd instead.
        local buf_path = vim.api.nvim_buf_get_name(0)
        local seed = vim.fn.getcwd()
        if vim.bo.buftype == "" and buf_path ~= "" then
          seed = vim.fs.normalize(vim.fn.fnamemodify(buf_path, ":p:h"))
        end

        -- 3. One terminal per project tree: reuse a terminal in the
        --    same slot whose cwd lives in the same tree as the seed.
        --    `descendants_of(a, root)` is true when `a` starts with the
        --    literal `root` prefix, i.e. a is inside root (or root itself
        --    minus the trivial case).
        local descendants_of = function(dir, root)
          if dir == root then
            return false
          end
          local prefix = root == "/" and "/" or root .. "/"
          return dir:sub(1, #prefix) == prefix
        end

        local best
        for _, term in ipairs(terminal.list()) do
          -- A candidate must live in the same slot (`id`) and share the
          -- window-position the key renders with, so e.g. the float shell
          -- and the listed shell never steal each other's terminal.
          local position_ok = position == nil
            or (term.opts and term.opts.position == position)
            or (
              term.win
              -- `term.win` can outlive the window itself (e.g. the terminal
              -- was hidden when its buffer closed); guard before touching it.
              and vim.api.nvim_win_is_valid(term.win)
              and vim.w[term.win].snacks_win
              and vim.w[term.win].snacks_win.position == position
            )
          local meta = term.buf and vim.b[term.buf].snacks_terminal
          if position_ok and meta and meta.cmd == cmd and meta.id == count and meta.cwd then
            -- Score: 2 = exact cwd, 1 = seed is inside the terminal's tree,
            -- 0 = the terminal's tree is inside the seed. Anything else is
            -- a different project tree and must not be reused.
            local tier
            if meta.cwd == seed then
              tier = 2
            elseif descendants_of(seed, meta.cwd) then
              tier = 1
            elseif descendants_of(meta.cwd, seed) then
              tier = 0
            end
            if tier then
              -- Most specific tree wins; longer paths break ties.
              local score = tier * 100000 + #meta.cwd
              if not best or score > best.score then
                best = { meta = meta, score = score }
              end
            end
          end
        end
        if best then
          open(best.meta.cwd, true)
          return
        end

        -- 4. No related terminal in this slot: spawn one seeded
        --    from the buffer's directory.
        open(seed, true)
      end
    '';
}
