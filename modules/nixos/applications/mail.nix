{ config, lib, ... }:

lib.mkIf config.custom.desktop.enable {
  home-manager.users.${config.custom.mainUser}.imports = [
    {
      programs.thunderbird = {
        enable = true;
        languagePacks = [ "zh-CN" ];
        policies.DisableTelemetry = true;
      };
    }
  ];
}
