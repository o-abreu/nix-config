{
  config,
  lib,
  options,
  ...
}:
{
  config = lib.optionalAttrs (options ? programs.nixvim) {
    programs.nixvim.keymaps =
      [
        {
          key = "<leader>te";
          action = "<cmd>Yazi<cr>";
          options.desc = "Open Yazi at the current file";
        }
        {
          key = "<leader>tw";
          action = "<cmd>Yazi cwd<cr>";
          options.desc = "Open Yazi at nvim's cwd";
        }
        {
          key = "<leader>uy";
          action = "<cmd>Yazi toggle<cr>";
          options.desc = "Resume previous Yazi session";
        }
      ]
      |> map (
        m:
        m
        // {
          mode = "n";
          options.silent = true;
        }
      )
      |> lib.mkIf config.programs.nixvim.plugins.yazi.enable;
  };
}
