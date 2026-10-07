{
  description = "A NixOS configuration with impermanence";

  inputs = {
    # INFO: Core system inputs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # INFO: Stable package set for packages that do not build on unstable yet.
    # Exposed as `pkgs.stable` via overlays/stable-packages.nix. Every consumer
    # must link the upstream issue in a comment and drop it once nixpkgs catches
    # up — see TODO.md.
    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/nixos-26.05";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    preservation.url = "github:nix-community/preservation";

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wrappers = {
      url = "github:Lassulus/wrappers";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    import-tree.url = "github:vic/import-tree";

    # INFO: Desktop environment
    hydenix = {
      url = "github:richen604/hydenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    stylix.url = "github:nix-community/stylix/master";

    # INFO: System and hardware
    systems.url = "github:nix-systems/default-linux";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";

    # INFO: Provide the Comma tool
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # INFO: Nixvim
    nixvim.url = "github:nix-community/nixvim/main";

    neotest-nix.url = "github:khaneliman/neotest-nix";

    alpha-ascii-nvim = {
      url = "github:nhattVim/alpha-ascii.nvim/main";
      flake = false;
    };

    qalc-nvim = {
      url = "github:Apeiros-46B/qalc.nvim/main";
      flake = false;
    };

    sshfs-nvim = {
      url = "github:uhs-robert/sshfs.nvim/main";
      flake = false;
    };

    vim-slime-cells = {
      url = "github:Klafyvel/vim-slime-cells/main";
      flake = false;
    };

    presenterm-nvim = {
      url = "github:Piotr1215/presenterm.nvim";
      flake = false;
    };

    crazy-coverage-nvim = {
      url = "github:mr-u0b0dy/crazy-coverage.nvim/main";
      flake = false;
    };

    markdown-plus-nvim = {
      url = "github:YousefHadder/markdown-plus.nvim/main";
      flake = false;
    };

    nvim-prose = {
      url = "github:skwee357/nvim-prose/main";
      flake = false;
    };

    # INFO: OpenCode
    anthropics-skills = {
      url = "github:anthropics/skills";
      flake = false;
    };

    upstash-context7 = {
      url = "github:upstash/context7";
      flake = false;
    };

    hyprmcp = {
      url = "github:stefanoamorelli/hyprmcp/master";
      flake = false;
    };

    # INFO: Asta (research skills + `asta` CLI). Keep this tag equal to the
    # PLUGIN_VERSION embedded in the plugin's skills, otherwise the `asta-cli`
    # skill tries to `uv tool install` at runtime. See TODO.md.
    asta-plugins = {
      url = "github:allenai/asta-plugins/v0.106.0";
      flake = false;
    };

    # INFO: Zotero MCP / zotero-cli (github:54yyyu/zotero-mcp). `flake = false`;
    # pkgs/zotero-mcp builds the CLI via uv2nix and tools/zotero vendors the
    # bundled skill. Keep the tag in sync with pkgs/zotero-mcp/uv.lock (TODO.md).
    zotero-mcp = {
      url = "github:54yyyu/zotero-mcp/v0.13.3";
      flake = false;
    };

    # INFO: Python packaging for the `asta` CLI (pkgs/asta).
    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    uv2nix = {
      url = "github:pyproject-nix/uv2nix";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pyproject-build-systems = {
      url = "github:pyproject-nix/build-system-pkgs";
      inputs.pyproject-nix.follows = "pyproject-nix";
      inputs.uv2nix.follows = "uv2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # INFO: Yazi
    nix-yazi-plugins = {
      url = "github:lordkekz/nix-yazi-plugins";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    cd-git-root = {
      url = "github:ciarandg/cd-git-root.yazi";
      flake = false;
    };

    faster-piper = {
      url = "github:alberti42/faster-piper.yazi";
      flake = false;
    };

    smart-arrow = {
      url = "github:jessefarinacci/smart-arrow.yazi";
      flake = false;
    };

    yaziline = {
      url = "github:llanosrocas/yaziline.yazi";
      flake = false;
    };

    # INFO: WezTerm
    tabline-wez = {
      url = "github:michaelbrusegard/tabline.wez";
      flake = false;
    };

    smart-splits-nvim = {
      url = "github:mrjones2014/smart-splits.nvim";
      flake = false;
    };

    wezterm-unicode-input = {
      url = "github:de-abreu/wezterm-unicode-input";
      flake = false;
    };

    # INFO: Zotero
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vortriz-nur = {
      url = "github:Vortriz/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs: import ./outputs.nix inputs;
}
