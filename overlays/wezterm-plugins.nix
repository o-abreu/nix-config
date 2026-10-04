# INFO: WezTerm plugins built from non-flake git inputs.
#
# Inputs are declared with `flake = false` in flake.nix. Each entry is exposed
# for the wezterm-override home module as
# `pkgs.weztermPlugins.<input-name> = { url, src }`, so the module does not
# have to infer canonical repository URLs from flake.lock itself.
#
# Any forge supported by the Nix fetchers works: `github`, `gitlab`,
# `sourcehut` (via owner/repo, with optional self-hosted `host`) and generic
# `git` URLs (e.g. Codeberg/Gitea/self-hosted). WezTerm itself accepts any git
# URL, so no forge-specific restriction is applied here.
#
# Adding a plugin: declare the input in flake.nix, then add its name here.
#
# Every entry carries `name`, so a consumer can hand the whole record to
# `programs.wezterm.plugins` without repeating the name:
#
#     plugins = with pkgs.weztermPlugins; [ tabline-wez ];
#
# and the module still knows to install it as `plugins/tabline-wez/`, which is
# what `require("plugins.tabline-wez")` resolves. So a plugin must appear both
# here (to be catalogued) and in some module's `plugins` (to be registered).
{ inputs, lib, ... }:
_final: _prev:
let
  plugins = [
    "smart-splits-nvim"
    "tabline-wez"
    "wezterm-unicode-input"
  ];

  lock = builtins.fromJSON (builtins.readFile "${inputs.self}/flake.lock");

  # INFO: Infer the canonical repository URL from flake.lock. Flake input
  # attrsets do not carry owner/repo, but the lock node whose name matches the
  # input records the original ref (e.g. { type = "github"; owner; repo; }).
  # A direct name lookup avoids walking every node in flake.lock. The rev check
  # hard-errors if flake.nix and flake.lock are desynchronized (e.g. via
  # --override-input).
  pluginUrl =
    name:
    assert lib.assertMsg
      (lock.nodes.${name}.locked.rev == inputs.${name}.rev)
      "wezterm-plugins: lock/input rev mismatch for '${name}'";
    let
      node = lock.nodes.${name};
      o = node.original or { };
      # Drop any ?ref=/?dir= query suffix from a generic git URL.
      stripQuery = url: builtins.head (lib.splitString "?" url);
    in
    if o.type == "github" then
      "https://${o.host or "github.com"}/${o.owner}/${o.repo}"
    else if o.type == "gitlab" then
      "https://${o.host or "gitlab.com"}/${o.owner}/${o.repo}"
    else if o.type == "sourcehut" then
      "https://${o.host or "git.sr.ht"}/${o.owner}/${o.repo}"
    else if o.type == "git" then
      lib.removePrefix "git+" (stripQuery o.url)
    else
      throw "wezterm-plugins: unsupported input type '${o.type}' for input '${name}'";
in
{
  weztermPlugins =
    plugins
    |> map (
      name:
      lib.nameValuePair name {
        # INFO: `name` makes the entry self-describing, so `programs.wezterm.plugins`
        # can take a bare list of entries and still key each one correctly.
        inherit name;
        url = pluginUrl name;
        src = inputs.${name};
      }
    )
    |> lib.listToAttrs;
}
