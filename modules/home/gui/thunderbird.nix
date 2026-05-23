{ osConfig, lib, ... }:

lib.mkIf osConfig.custom.desktop.enable {
  programs.thunderbird = {
    enable = true;
    languagePacks = [ "zh-CN" ];
    policies.DisableTelemetry = true;
  };
}
