{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) getExe';
  lazyLoad.settings.ft = ["c" "cpp"];
in {
  programs.nixvim = {
    # INFO: `ctest` is not auto-provisioned by nixvim, unlike `jdtls`, which
    # ships its own language server. neotest-ctest shells out to it by name.
    extraPackages = [pkgs.cmake];

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
        neotest.adapters.ctest = {
          enable = true;
          settings = {
            cmd = [(getExe' pkgs.cmake "ctest")];
            # INFO: Matches the dap-lldb adapter name wired in below, so
            # `<leader>Td` debugs tests without any extra dap configuration.
            dap_adapter = "codelldb";
            # INFO: Upstream only matches `*_test.{cpp,cc,cxx}`. Widen to `.c`
            # and `test_*` so C test files are considered at all.
            is_test_file.__raw = ''
              function(file_path)
                local name, ext = unpack(vim.split(vim.fs.basename(file_path), ".", { plain = true }))
                return vim.tbl_contains({ "c", "cc", "cpp", "cxx" }, ext)
                  and (vim.endswith(name, "_test") or vim.startswith(name, "test_"))
              end
            '';
            # INFO: `unity` is a local module, not a nixpkgs one. neotest-ctest
            # resolves framework modules through the Lua loader, so any runtimepath
            # entry works; see `util/lua/neotest-ctest/framework/unity.lua`.
            frameworks = ["unity" "gtest" "catch2" "doctest" "cpputest"];
          };
        };

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
