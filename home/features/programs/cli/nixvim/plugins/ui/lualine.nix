{
  programs.nixvim = {
    autoCmd = [
      {
        event = [
          "RecordingEnter"
          "RecordingLeave"
        ];
        callback.__raw = ''
          function()
            require('lualine').refresh()
          end
        '';
      }
    ];

    plugins.lualine = {
      enable = true;
      lazyLoad.settings.event = "DeferredUIEnter";
    };
  };
}
