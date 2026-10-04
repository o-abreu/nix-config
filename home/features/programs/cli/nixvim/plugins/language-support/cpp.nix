{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) getExe';
  lazyLoad.settings.ft = ["c" "cpp"];
in {
  programs.nixvim = {
    lsp.servers = {
      cmake.enable = true;

      clangd = {
        enable = true;
        config = {
          root_markers = [
            ".clangd"
            "compile_commands.json"
            "compile_flags.txt"
            ".git"
          ];
          settings.init_options = {
            usePlaceholders = true;
            completeUnimported = true;
            clangdFileStatus = true;
          };
          cmd = [
            "${getExe' pkgs.clang-tools "clangd"}"
            "--background-index"
            "--clang-tidy"
            "--completion-style=detailed"
            "--function-arg-placeholders"
            "--fallback-style=llvm"
          ];
        };
      };
    };

    autoCmd = [
      {
        event = "FileType";
        pattern = [
          "c"
          "cpp"
        ];
        command = "setlocal tabstop=4";
      }
    ];

    plugins =
      {
        conform-nvim.settings = {
          formatters_by_ft = {
            cpp = ["clang-format"];
            cmake = ["cmake_format"];
          };

          formatters = {
            clang-format.command = getExe' pkgs.clang-tools "clang-format";
            cmake_format.command = getExe' pkgs.cmake-format "cmake-format";
          };
        };

        lint = {
          lintersByFt = {
            cpp = ["clangtidy"];
            cmake = ["cmakelint"];
          };

          linters = {
            clangtidy.cmd = getExe' pkgs.clang-tools "clang-tidy";
            cmakelint.cmd = getExe' pkgs.cmake-format "cmake-lint";
          };
        };

        clangd-extensions = {
          enable = true;
          settings = {
            inlay_hints = {
              inline = false;
            };
            codelens.enable = true;

            ast = {
              roleIcons = {
                type = "";
                declaration = "";
                expression = "";
                specifier = "";
                statement = "";
                templateArgument = "";
              };
              kindIcons = {
                compound = "";
                recovery = "";
                translationUnit = "";
                packExpansion = "";
                templateTypeParm = "";
                templateTemplateParm = "";
                templateParamObject = "";
              };
            };
          };
        };

        dap-lldb = {
          enable = true;
          settings.codelldb_path = getExe' pkgs.vscode-extensions.vadimcn.vscode-lldb.adapter "codelldb";
          inherit lazyLoad;
        };
      }
      // (lib.genAttrs ["dap" "dap-ui" "dap-virtual-text"] (_: {inherit lazyLoad;}));

    files = lib.genAttrs ["ftplugin/c.nix" "ftplugin/cpp.nix"] (_: {
      opts.tabstop = 4;
    });
  };
}
