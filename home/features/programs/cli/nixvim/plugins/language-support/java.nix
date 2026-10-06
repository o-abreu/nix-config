# INFO: Java language support using nvim-jdtls
# DAP bundles are extracted from vscode extensions.
{
  lib,
  pkgs,
  ...
}: {
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

          init_options.bundles.__raw = let
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
        formatters_by_ft.java = ["google-java-format"];
        formatters.google-java-format = {
          command = lib.getExe pkgs.google-java-format;
          timeout = 10000;
        };
      };

      # INFO: No JDK goes on Neovim's PATH. neotest-java resolves `java` and
      # `javap` at runtime by asking jdtls for `org.eclipse.jdt.ls.core.vm.location`,
      # and nixpkgs' jdt-language-server is built against openjdk-21. Classpaths
      # likewise come from jdtls via `java.project.getClasspaths`, so Maven and
      # Gradle binaries are unnecessary too. The build tool is auto-detected from
      # `pom.xml`/`mvnw` vs `*.gradle`/`gradlew` markers.
      neotest.adapters.java = {
        enable = true;
        settings = {
          # INFO: Supply the JUnit Platform Console Standalone jar from the Nix
          # store instead of letting the adapter fetch it on `:NeotestJava setup`.
          # The adapter only stats this path before running, so a read-only store
          # path is enough, and the digest matches the one it hardcodes. Bump
          # `pkgs/junit-platform-console-standalone` to move to a newer JUnit;
          # `nix flake update` will not, which is the same contract as every other
          # pinned source here.
          junit_jar = "${pkgs.junit-platform-console-standalone}/junit-platform-console-standalone-6.0.3.jar";

          incremental_build = true;

          # INFO: Usually redundant, since the notification only fires for a jar
          # found in `stdpath("data")/neotest-java` and nothing is downloaded there
          # any more. It still matters for a machine that ran `:NeotestJava setup`
          # before this config: that leaves a jar behind, and once a future
          # neotest-java pins a newer version, the notice would tell the user to
          # upgrade a file that `junit_jar` above overrides anyway.
          disable_update_notifications = true;
          test_classname_patterns = [
            "^.*Tests?$"
            "^.*IT$"
            "^.*Spec$"
          ];
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
