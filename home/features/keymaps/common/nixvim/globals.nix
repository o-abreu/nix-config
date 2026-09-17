{ lib, options, ... }:
{
  config = lib.optionalAttrs (options ? programs.nixvim) {
    programs.nixvim.globals = {
      mapleader = " ";
      maplocalleader = ",";
    };
  };
}
