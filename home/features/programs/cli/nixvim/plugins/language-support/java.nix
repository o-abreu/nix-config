# INFO: Java language support using nvim-jdtls
# DAP bundles are extracted from vscode extensions.
{ lib, pkgs, ... }:
{
  programs.nixvim = {
    plugins = {
      jdtls = {
        enable = true;

        settings = {
          cmd = [
            "jdtls"
            "-Xms1g"
            "-javaagent:${pkgs.lombok}/share/java/lombok.jar"
            "-data"
            {
              __raw = "vim.fn.stdpath('data') .. '/java/workspace-root/' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')";
            }
          ];

          root_dir.__raw = "vim.fs.root(0, {'.root', 'mvnw', 'gradlew'})";

          settings.java = {
            eclipse = {
              downloadSources = true;
            };
            configuration.updateBuildConfiguration = "interactive";
            maven.downloadSources = true;
            implementationsCodeLens.enabled = true;
            referencesCodeLens.enabled = true;
            inlayHints.parameterNames.enabled = "all";
            signatureHelp.enabled = true;
            completion.favoriteStaticMembers = [
              "org.hamcrest.MatcherAssert.assertThat"
              "org.hamcrest.Matchers.*"
              "org.hamcrest.CoreMatchers.*"
              "org.junit.jupiter.api.Assertions.*"
              "java.util.Objects.requireNonNull"
              "java.util.Objects.requireNonNullElse"
              "org.mockito.Mockito.*"
            ];
            sources.organizeImports = {
              starThreshold = 9999;
              staticStarThreshold = 9999;
            };
          };

          # INFO: `__raw` in a *table value* position must be a single Lua
          # expression, so this whole block is wrapped in an IIFE. Emitting the
          # bare statements instead produces `bundles = local bundles = {}`,
          # which is a syntax error and fails the build in stylua — not in
          # `nix flake check`, which only evaluates and never builds.
          init_options.bundles.__raw =
            let
              inherit (pkgs.vscode-extensions.vscjava) vscode-java-debug vscode-java-test;
              server = id: pkg: "${pkg}/share/vscode/extensions/${id}/server/*.jar";
            in
            # lua
            ''
              (function()
                local bundles = {}

                local function add(glob, excluded)
                  excluded = excluded or {}
                  for _, jar in ipairs(vim.fn.glob(glob, 1, 1)) do
                    if not vim.tbl_contains(excluded, vim.fn.fnamemodify(jar, ":t")) then
                      table.insert(bundles, jar)
                    end
                  end
                end

                add("${server "vscjava.vscode-java-debug" vscode-java-debug}")
                -- INFO: the test runner and the coverage agent are not OSGi bundles
                add("${server "vscjava.vscode-java-test" vscode-java-test}", {
                  "com.microsoft.java.test.runner-jar-with-dependencies.jar",
                  "jacocoagent.jar",
                })

                return bundles
              end)()
            '';
        };
      };

      conform-nvim.settings = {
        formatters_by_ft.java = [ "google-java-format" ];
        formatters.google-java-format = {
          command = lib.getExe pkgs.google-java-format;
          timeout = 10000;
        };
      };
    };

    autoCmd = [
      {
        event = "LspAttach";
        pattern = "*.java";
        callback.__raw = ''
          function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client and client.name == "jdtls" then
              require('dap')
              require('jdtls.dap').setup_dap_main_class_configs()
            end
          end
        '';
      }
    ];
  };
}
