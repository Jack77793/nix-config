{
  config,
  lib,
  pkgs,
  ...
}:

{
  nix = {
    enable = true;
    package = pkgs.nix;
  };

  custom.mainUser = lib.mkDefault config.system.primaryUser;
}
