{ config, lib, ... }:

lib.mkIf config.custom.desktop.enable {
  home-manager.users.${config.custom.mainUser} = {
    programs.aria2.systemd.enable = true;
  };
}
