{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkMerge [
    (lib.mkIf config.custom.hostDefaults.enable {
      programs.proxychains = {
        enable = true;
        package = pkgs.proxychains-ng;
        proxies.sing-box = {
          enable = true;
          type = "socks5";
          host = "127.0.0.1";
          port = 2012;
        };
      };
    })

    (lib.mkIf config.services.sing-box.enable {
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
    })

    (lib.mkIf config.services.dae.enable {
      services.dae = {
        configFile = config.age.secrets."config.dae".path;
      };
    })
  ];
}
