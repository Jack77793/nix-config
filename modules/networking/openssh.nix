{ config, lib, ... }:

lib.mkMerge [
  {
    services.openssh.enable = lib.mkDefault config.custom.hostDefaults.enable;
  }

  (lib.mkIf config.services.openssh.enable {
    services.openssh = {
      openFirewall = true;
      ports = lib.mkDefault [ 484 ];
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = lib.mkDefault false;
        PermitRootLogin = "no";
      };
    };

    environment.enableAllTerminfo = true;
  })
]
