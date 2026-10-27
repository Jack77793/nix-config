{ config, lib, ... }:

lib.mkIf config.custom.desktop.enable {
  home-manager.users.${config.custom.mainUser} = {
    programs.thunderbird = {
      enable = true;
      languagePacks = [ "zh-CN" ];
      policies.DisableTelemetry = true;
    };
  };
}
