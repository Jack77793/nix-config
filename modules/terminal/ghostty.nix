{ config, lib, ... }:

lib.mkIf config.custom.desktop.enable {
  home-manager.users.${config.custom.mainUser}.imports = [
    ../../home/modules/terminal/ghostty.nix
  ];
}
