# INFO: Shared layout factory for snacks.terminal keys. Given a `toggleTerm`
# action builder (see `_toggle-term.nix`), it returns `allLayouts`, which expands
# a keymap prefix into the float / vertical / horizontal toggle bindings.
{
  lib,
  toggleTerm,
}:
{
  prefix,
  count ? null,
  cmd ? null,
  bindSlime ? false,
  resolve ? null,
  label ? "terminal",
}:
[
  {
    key = "f";
    position = "float";
    desc = "Floating ${label}";
  }
  {
    key = "v";
    position = "right";
    desc = "Vertical split ${label}";
  }
  {
    key = "h";
    position = "bottom";
    desc = "Horizontal split ${label}";
  }
]
|> lib.map (layout: {
  key = prefix + layout.key;
  action = toggleTerm {
    inherit cmd bindSlime resolve;
    opts = {
      inherit count;
      win.position = layout.position;
    };
  };
  options.desc = layout.desc;
})
