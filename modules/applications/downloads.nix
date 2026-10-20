{ config, lib, ... }:

lib.mkIf config.custom.desktop.enable {
  home-manager.users.${config.custom.mainUser} = {
    imports = [ ../../home/modules/applications/downloads.nix ];
    programs.aria2.systemd.enable = true;
  };
}
