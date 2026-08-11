{
  config,
  lib,
  ...
}:
{

  # Strip nvim-treesitter dependency from companion plugins (fixes the "two versions of treesitter installed" error).
  nixpkgs.overlays = [
    (_: prev: {
      vimPlugins =
        prev.vimPlugins
        // (lib.genAttrs
          [
            "nvim-treesitter-context"
            "nvim-treesitter-refactor"
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

    settings = {
      highlight = {
        additional_vim_regex_highlighting = true;
        disable = ''
          function(lang, bufnr)
            return vim.api.nvim_buf_line_count(bufnr) > 10000
          end
        '';
      };

      incremental_selection.enable = true;
    };
  };
}
