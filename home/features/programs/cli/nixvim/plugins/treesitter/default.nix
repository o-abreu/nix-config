{
  config,
  lib,
  ...
}:
{

  # INFO: Strip nvim-treesitter dependency from companion plugins (fixes the "two versions of treesitter installed" error).
  nixpkgs.overlays = [
    (_: prev: {
      vimPlugins =
        prev.vimPlugins
        // (lib.genAttrs
          [
            "nvim-treesitter-context"
            "nvim-treesitter-textobjects"
            "ts-comments-nvim"
          ]
          (
            name:
            prev.vimPlugins.${name}.overrideAttrs (_: {
              dependencies = [ ];
              doCheck = false;
            })
          )
        );
    })
  ];

  programs.nixvim.plugins.treesitter = {
    enable = true;

    grammarPackages =
      let
        # Large grammars that are not used
        excludedGrammars = [
          "agda"
          "cuda"
          "d"
          "fortran"
          "gnuplot"
          "haskell"
          "hlsl"
          "julia"
          "koto"
          "lean"
          "nim"
          "scala"
          "slang"
          "systemverilog"
          "tlaplus"
          "verilog"
        ];
      in
      config.programs.nixvim.plugins.treesitter.package.builtGrammars
      |> lib.filterAttrs (name: _: !(lib.elem name excludedGrammars))
      |> lib.attrValues;

    highlight.enable = true;
    indent.enable = true;
    folding.enable = false; # Disabled in favor of nvim-ufo

    settings.incremental_selection.enable = true;
  };

  # INFO: Disable treesitter highlighting for very large buffers (> 10k lines)
  programs.nixvim.extraConfigLua =
    # lua
    ''
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function(args)
          local bufnr = args.buf
          if vim.api.nvim_buf_line_count(bufnr) > 10000 then
            vim.schedule(function()
              pcall(vim.treesitter.stop, bufnr)
            end)
          end
        end,
      })
    '';
}
