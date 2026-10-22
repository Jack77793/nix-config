{ lib, ... }:

{
  options.custom.mainUser = lib.mkOption {
    type = lib.types.nonEmptyStr;
    description = "The primary user whose Home Manager configuration is managed";
  };

  config._module.args.myVars = import ./vars.nix;
}
