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
    manager = lib.mkOption {
      type = lib.types.enum [
        "nm"
        "networkd"
      ];
      default = "nm";
      description = "The network backend to use. when set to networkd, systemd-networkd network unit(s) must be configured per host";
    };
  };

  config = lib.mkIf config.custom.hostDefaults.enable {
    services.resolved.enable = true;

    networking = {
      timeServers = [
        "ntp.ntsc.ac.cn"
        "ntp.aliyun.com"
      ];
    };
  };
}
