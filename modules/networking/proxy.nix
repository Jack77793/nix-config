{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkMerge [
  {
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
  }

  (lib.mkIf config.custom.extras.sing-box.enable {
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
  })

  (lib.mkIf config.custom.extras.dae.enable {
    services.dae = {
      enable = true;
      configFile = config.age.secrets."config.dae".path;
    };
  })
]
