{
  config,
  lib,
  pkgs,
  _class,
  ...
}:

{
  home-manager.users.${config.custom.mainUser} = {
    imports = lib.optional config.custom.development.enable ./home.nix;
    home.packages = lib.optionals (config.custom.development.enable && _class == "nixos") [
      pkgs.bubblewrap
    ];
  };
}
