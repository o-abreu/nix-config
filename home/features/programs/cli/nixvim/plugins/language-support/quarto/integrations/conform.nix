{
  programs.nixvim = {
    # INFO: `runtime/ftplugin/quarto.vim` sources `ftplugin/rmd.vim`, which does
    # `setlocal formatexpr=FormatRmd()`, shadowing the global
    # `v:lua.require'conform'.formatexpr()`. Re-assert conform so `gq` / visual
    # `=` go through it like `:Format` and format-on-save do. This autocmd is
    # registered at the end of init.lua, so it runs after the one in
    # `runtime/ftplugin.vim`.
    extraConfigLua =
      # lua
      ''
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "quarto",
          callback = function(args)
            -- `formatexpr` is global-local, so it must be set through the option
            -- API: a `vim.b` assignment only defines a `b:formatexpr` variable.
            vim.api.nvim_set_option_value(
              "formatexpr",
              "v:lua.require'conform'.formatexpr()",
              { buf = args.buf }
            )
          end,
        })
      '';

    # INFO: conform's built-in `deno_fmt` maps filetype -> `deno fmt --ext <ext>`
    # and its map has no `quarto` entry, so the value is dropped when argv is
    # flattened and deno exits with "a value is required for '--ext'".
    # `formatters_by_ft` cannot carry arguments, so a quarto-specific formatter
    # inherits `deno_fmt` for its `command` and pins the extension to markdown
    # instead (quarto is markdown plus pandoc markup).
    plugins.conform-nvim.settings = {
      formatters.deno_fmt_quarto = {
        "inherit" = "deno_fmt";
        args = ["fmt" "-" "--ext" "md"];
      };
      formatters_by_ft.quarto = ["deno_fmt_quarto"];
    };
  };
}
