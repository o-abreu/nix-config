{
  config,
  lib,
  ...
}: let
  inherit (config.programs.opencode) agents;
in {
  programs.opencode.settings.agent = with config.lib.stylix.colors.withHashtag; {
    build.color = base0F;
    plan.color = base0E;
    research.color = lib.mkIf (agents ? research) base0D;
    learn.color = lib.mkIf (agents ? learn) base0B;
  };
}
