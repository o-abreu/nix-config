{ inputs, ... }:
{
  programs.yazi.plugins = { inherit (inputs) faster-piper; };
}
