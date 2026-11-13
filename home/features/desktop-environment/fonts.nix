# INFO: Extra fonts installed into the user profile and discovered via
# fontconfig (fonts.fontconfig.enable = true), beyond the roles stylix
# assigns in `themes/`.
{pkgs, ...}: {home.packages = [pkgs.readexpro];}
