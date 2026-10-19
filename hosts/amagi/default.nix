{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [ ./hardware-configuration.nix ];

  custom = {
    profile = "headless";

    stateVersion = "26.11";
  };

  boot.lanzaboote.enable = true;

  networking = {
    hostName = "Amagi";
    useDHCP = false;
    nameservers = [ "192.168.1.72" ];
  };

  systemd.network.networks."20-ethernet" = {
    matchConfig.Name = "en*";
    address = [ "192.168.1.73/24" ];
    routes = [
      { Gateway = "192.168.1.1"; }
    ];
    linkConfig.RequiredForOnline = "routable";
  };

  networking.firewall.allowedTCPPorts = [ 25565 ];

  services = {
    tailscale.enable = true;
    tuned.ppdSettings.main.default = lib.mkForce "throughput-performance";
  };

  programs.proxychains.proxies = lib.mkForce {
    sing-box = {
      enable = true;
      type = "socks5";
      host = "192.168.1.72";
      port = 2012;
    };
  };

  programs.dconf.enable = true;

  home-manager.users.${config.custom.mainUser} = {
    home.packages = with pkgs; [
      frp
    ];
    programs.java = {
      enable = true;
      package = pkgs.zulu25;
    };
  };
}
