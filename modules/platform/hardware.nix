{ config, lib, ... }:

lib.mkIf config.custom.hostDefaults.enable {
  services = {
    fwupd.enable = true;

    tuned = {
      enable = true;
      settings.dynamic_tuning = true;
      ppdSupport = true;
      ppdSettings.main.default = "balanced";
    };

    logind.settings.Login = {
      HandleLidSwitch = "suspend";
      HandlePowerKey = "suspend";
      KillUserProcesses = false;
    };

    upower.enable = true;
    power-profiles-daemon.enable = false;
    tlp.enable = false;
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    priority = lib.mkDefault 100;
    memoryPercent = lib.mkDefault 50;
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = lib.mkDefault 160;
    "vm.watermark_boost_factor" = lib.mkDefault 0;
    "vm.watermark_scale_factor" = lib.mkDefault 125;
    "vm.page-cluster" = lib.mkDefault 0;
  };

  environment.persistence."/nix/persist".directories = [
    "/var/lib/fwupd"
    "/var/lib/upower"
  ];
}
