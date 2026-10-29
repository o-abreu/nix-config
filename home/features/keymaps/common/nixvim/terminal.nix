{
  programs.nixvim.keymaps = [
    {
      key = "<leader>tn";
      action = "<cmd>terminal<cr>";
      options.desc = "New terminal buffer";
    }
  ];
}
