# INFO: Whenever the cursor jumps, the entire line where it lands blinks, making
# it easier after quick movements. Was not able to make these animations activate,
# I do not know why.
{
  programs.nixvim.plugins = {
    tiny-glimmer = {
      enable = true;
      autoLoad = true;
      settings = {
        overwrite = {
          search.enabled = true;
          undo.enabled = true;
          redo.enabled = true;
        };
        presets.pulsar.enabled = false;
      };
    };
    yanky.settings.highlight = {
      on_put = false;
      on_yank = false;
    };
  };
}
