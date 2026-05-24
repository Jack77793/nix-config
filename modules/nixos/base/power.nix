{
  services = {
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

  environment.persistence."/nix/persist".directories = [
    "/var/lib/upower"
  ];
}
