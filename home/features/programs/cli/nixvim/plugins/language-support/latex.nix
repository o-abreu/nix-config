{
  programs.nixvim = {
    plugins = {
      vimtex.enable = true;
      lsp.servers.texlab.enable = true;
      cmp-vimtex.enable = true;
      blink-cmp-latex.enable = true;
    };
    # Enable Vimtex concealment and replacement of latex math and control characters.
    globals.conceallevel = 2;
  };
}
