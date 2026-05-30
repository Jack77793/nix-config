{ config, lib, ... }:

lib.mkIf config.custom.extras.sing-box.enable {
  services.sing-box.enable = true;

  systemd.services.sing-box.environment = {
    RUNTIME_DIRECTORY = "/etc/sing-box";
  };

  # networking.firewall.trustedInterfaces = [ "sing-tun" ];

  environment.persistence."/nix/persist".directories = [
    {
      directory = "/var/lib/sing-box";
      user = "sing-box";
      mode = "0700";
    }
  ];
}
