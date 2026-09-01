{
  pkgs,
  ...
}:
{
  imports = [ ../common.nix ];

  stylix = with pkgs; {
    enable = true;
    image = ./old.png;
    base16Scheme = ./astrodark.yaml;
    polarity = "dark";

    fonts = {
      serif = {
        package = libre-baskerville;
        name = "LibreBaskerville";
      };
      sansSerif = {
        package = inter;
        name = "Inter";
      };
      monospace = {
        package = nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
      emoji = {
        package = noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        terminal = 12;
        desktop = 14;
      };
    };

    cursor = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };
}
