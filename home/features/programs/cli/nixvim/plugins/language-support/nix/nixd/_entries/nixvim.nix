# INFO: nixvim option scope for nixd (Home-Manager only, flake-value module)
{ inputs, lib, ... }:
{
  home-manager = lib.optional (inputs ? nixvim) {
    attr = ''nixvim = builtins.getFlake "${inputs.nixvim}";'';
    mod = ''(builtins.getFlake "${inputs.nixvim}").homeModules.nixvim'';
  };
}