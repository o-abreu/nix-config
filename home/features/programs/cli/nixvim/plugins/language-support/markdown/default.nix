{
  lib,
  pkgs,
  ...
}:
{
  programs.nixvim = {
    # INFO: Set the mdx filetype as a variation of markdown, thus inheriting its configuration.
    filetype.filename.mdx = "markdown.mdx";

    plugins = {
      lsp.servers.marksman = {
        enable = true;
        filetypes = [ "markdown" ];
      };

      markdown-preview = {
        enable = true;
        lazyLoad.settings.cmd =
          [
            ""
            "Stop"
            "Toggle"
          ]
          |> map (elem: "MarkdownPreview" + elem);
      };

      render-markdown = {
        enable = true;
        lazyLoad.settings.ft = [ "markdown" ];
        settings = {
          file_types = [ "markdown" ];
          # Keep Setext headings (===, ---) as-is instead of rendering as ATX (#)
          heading.setext = false;
          # Show concealed text (e.g., HTML comments) as greyed out instead of hidden
          win_options.conceallevel.rendered = 2;
        };
      };

      conform-nvim.settings.formatters_by_ft.markdown = [ "deno_fmt" ];
      lint = {
        lintersByFt.markdown = [ "markdownlint" ];
        linters.markdownlint.cmd = lib.getExe pkgs.markdownlint-cli;
      };
    };
  };
}
