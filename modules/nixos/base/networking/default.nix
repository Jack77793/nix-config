{ config, ... }:

{
  imports = [
    ./avahi.nix
    ./firewall.nix
    ./networkd.nix
    ./nm.nix
    ./openssh.nix
  ];

  services.resolved.enable = true;

  networking = {
    hostName = config.custom.networking.hostname;

    timeServers = [
      "ntp.ntsc.ac.cn"
      "ntp.aliyun.com"
    ];
  };
}
