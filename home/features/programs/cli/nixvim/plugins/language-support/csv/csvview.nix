{
  programs.nixvim = {
    plugins.csvview = {
      enable = true;

      lazyLoad.settings = {
        cmd = [
          "CsvViewEnable"
          "CsvViewDisable"
          "CsvViewToggle"
          "CsvViewInfo"
        ];
        ft = ["csv" "tsv"];
      };

      settings = {
        parser.comments = ["#" "//"];
        view.display_mode = "border";
      };
    };

    autoCmd = [
      {
        event = ["FileType"];
        pattern = ["csv" "tsv"];
        callback.__raw = ''
          function(args)
            local buf = args.buf

            -- INFO: lz.n re-fires the event that loaded a lazy plugin, which
            -- would run CsvViewEnable a second time while the first async
            -- parse is still running. The view is only registered after that
            -- parse finishes, so the second attach warns "already attached".
            -- CsvViewEnable sets this buffer variable synchronously, so this
            -- also catches the re-fired event.
            if vim.b[buf].csvview_info ~= nil then
              return
            end

            vim.api.nvim_buf_call(buf, function()
              vim.cmd("CsvViewEnable")
            end)
          end
        '';
      }
    ];
  };
}
