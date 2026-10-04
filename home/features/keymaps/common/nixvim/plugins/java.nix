# INFO: Java / jdtls keymaps
#
# Buffer-local, installed from `ftplugin/java.lua` like every other language, so
# they never shadow the `<leader>l*` mappings shared across filetypes.
# `<leader>lC` rather than `<leader>lc` because `lc` is taken by fastaction.
#
# `action.__raw` is required: a bare string rhs is stored verbatim by
# `vim.keymap.set` and then run as normal-mode commands instead of Lua.
#
# The gate is `jdtls.enable` rather than an `LspAttach` autocmd. An ftplugin runs
# on `filetype=java` whether or not jdtls ever attached, so if jdtls fails to
# start these maps exist but calling them errors instead of being absent.
{
  config,
  lib,
  ...
}:
let
  jdtls = config.programs.nixvim.plugins.jdtls;
  prefix = "<leader>l";

  bind = {
    key,
    action,
    desc,
    mode ? "n",
  }: {
    inherit key mode;
    action.__raw = action;
    options = {
      # INFO: `buffer = true`, never `<buffer>` inside `key`. Nixvim does not
      # parse the marker and would emit a *global* map with a literal
      # `<buffer>...` lhs.
      buffer = true;
      silent = true;
      inherit desc;
    };
  };
in
{
  programs.nixvim.files."ftplugin/java.lua".keymaps = lib.mkIf jdtls.enable [
    (bind {
      key = prefix + "o";
      action = "function() require('jdtls').organize_imports() end";
      desc = "Organize imports";
    })

    (bind {
      key = prefix + "v";
      action = "function() require('jdtls').extract_variable() end";
      desc = "Extract variable";
    })
    (bind {
      key = prefix + "v";
      action = "function() require('jdtls').extract_variable({ visual = true }) end";
      mode = "v";
      desc = "Extract variable (visual)";
    })

    (bind {
      key = prefix + "C";
      action = "function() require('jdtls').extract_constant() end";
      desc = "Extract constant";
    })
    (bind {
      key = prefix + "C";
      action = "function() require('jdtls').extract_constant({ visual = true }) end";
      mode = "v";
      desc = "Extract constant (visual)";
    })

    (bind {
      key = prefix + "m";
      action = "function() require('jdtls').extract_method({ visual = true }) end";
      mode = "v";
      desc = "Extract method";
    })

    (bind {
      key = "<leader>df";
      action = "function() require('jdtls').test_class() end";
      desc = "Debug test class";
    })
    (bind {
      key = "<leader>dn";
      action = "function() require('jdtls').test_nearest_method() end";
      desc = "Debug nearest test method";
    })
  ];
}