{ config, lib, ... }:

lib.mkIf config.custom.hostDefaults.enable {
  services.openssh = {
    enable = true;
    openFirewall = true;
    ports = [ 484 ];
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  environment.enableAllTerminfo = true;
}
