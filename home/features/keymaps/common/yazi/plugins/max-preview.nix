{ lib, options, ... }:
{
  config = lib.optionalAttrs (options ? programs.yazi.yaziPlugins) {
    programs.yazi.yaziPlugins.plugins.max-preview.keys.toggle = {
      on = [ "P" ];
      run = "plugin max-preview";
      desc = "Maximize or restore preview";
    };
  };
}
