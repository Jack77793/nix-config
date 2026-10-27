{
  config,
  lib,
  pkgs,
  _class,
  ...
}:

{
  imports = lib.optional (_class == "nixos") ./pi-auth.nix;

  home-manager.users.${config.custom.mainUser} = {
    imports = lib.optional config.custom.desktop.enable ./home.nix;
    home.packages = lib.optionals (config.custom.desktop.enable && _class == "nixos") [
      pkgs.bubblewrap
    ];
  };
}
