{
  inputs,
  lib,
  outputs,
  ...
}: {
  imports = [inputs.nixvim.homeModules.nixvim];

  # INFO: Many plugin authors do not bother to add a LICENSE file to their plugins. When LICENSE is absent, nixpkgs defensively assumes that the software is unfree.
  nixpkgs.config.allowUnfreePredicate = pkg: pkg.name or "" |> lib.hasPrefix "vimplugin-";

  programs = {
    nixvim = {
      enable = true;
      defaultEditor = true;
      nixpkgs.useGlobalPackages = true;
      viAlias = true;

      # INFO: Plugin modules authored for this flake (see `modules/nixvim/`).
      imports = builtins.attrValues outputs.nixvimModules;
    };
  };
  xdg.configFile = {
    "nvim/util/dot.lua".source = ./util/dot/init.lua;

    # INFO: Loaded by neotest-ctest through the Lua loader, which searches every
    # runtimepath entry. This is what makes the `unity` framework name in
    # `plugins.neotest.adapters.ctest.settings.frameworks` resolve without
    # patching the nixpkgs package. See
    # `util/lua/neotest-ctest/framework/unity.lua` and the matching
    # `unity-check.lua`, which asserts the treesitter queries against a fixture.
    "nvim/lua/neotest-ctest/framework/unity.lua".source = ./util/lua/neotest-ctest/framework/unity.lua;
    "nvim/lua/neotest-ctest/framework/unity-check.lua".source = ./util/lua/neotest-ctest/framework/unity-check.lua;
  };
}
