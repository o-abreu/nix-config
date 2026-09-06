# INFO: Whenever the cursor jumps, the entire line where it lands blinks, making
# it easier after quick movements
{
  programs.nixvim.plugins.tiny-glimmer = {
    enable = true;
    lazyLoad.settings.event = "BufReadPost";
  };
}
