{ config, lib, ... }:

{
  imports = [
    ./avahi.nix
    ./firewall.nix
    ./networkd.nix
    ./nm.nix
    ./openssh.nix
    ./proxy.nix
    ./smartdns.nix
    ./tailscale.nix
  ];

  options.custom.networking = {
    hostname = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "Hostname of the machine";
    };

    manager = lib.mkOption {
      type = lib.types.enum [
        "nm"
        "networkd"
      ];
      default = "nm";
      description = "The network backend to use. when set to networkd, systemd-networkd network unit(s) must be configured per host";
    };
  };

  config = {
    services.resolved.enable = true;

    networking = {
      hostName = config.custom.networking.hostname;

      timeServers = [
        "ntp.ntsc.ac.cn"
        "ntp.aliyun.com"
      ];
    };
  };
}
