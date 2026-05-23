{ config, ... }:

{
  imports = [
    ./avahi.nix
    ./firewall.nix
    ./nm.nix
    ./openssh.nix
    ./sing-box.nix
    ./tailscale.nix
  ];

  services.resolved.enable = true;

  networking = {
    hostName = config.custom.hostname;

    timeServers = [
      "ntp.ntsc.ac.cn"
      "ntp.aliyun.com"
    ];
  };
}
