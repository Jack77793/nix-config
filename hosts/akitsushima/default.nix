{
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./secrets.nix
  ];

  custom = {
    profile = "headless";

    networking.hostname = "Akitsushima";

    extras = {
      agenix.enable = true;
      qbittorrent.enable = true;
      secureboot.enable = true;
      sing-box.enable = true;
      smartdns.enable = true;
      tailscale.enable = true;
      virtualization.podman.enable = true;
    };

    stateVersion = "26.11";
  };

  networking.useDHCP = false;
  systemd.network.networks."20-ethernet" = {
    matchConfig.Name = "en*";
    address = [ "192.168.1.72/24" ];
    routes = [
      { Gateway = "192.168.1.1"; }
    ];
    linkConfig.RequiredForOnline = "routable";
  };

  networking.firewall.allowedTCPPorts = [
    2012
    22267
  ];

  services.tuned.ppdSettings.main.default = lib.mkForce "throughput-performance";

  services.qbittorrent.torrentingPort = 44678;

  programs.dconf.enable = true;

  virtualisation.oci-containers.containers = {
    alas = {
      image = "localhost/alas:latest";
      autoStart = true;
      extraOptions = [ "--network=host" ];
      volumes = [
        "/var/lib/alas:/app/AzurLaneAutoScript:rw"
        "/etc/localtime:/etc/localtime:ro"
      ];
    };
    android1 = {
      image = "docker.io/redroid/redroid:10.0.0-latest";
      autoStart = true;
      privileged = true;
      ports = [
        "127.0.0.1:5555:5555"
      ];
      volumes = [
        "/var/lib/redroid/android1:/data:rw"
      ];
      cmd = [
        "androidboot.redroid_width=1280"
        "androidboot.redroid_height=720"
        "androidboot.redroid_dpi=160"
        "androidboot.use_memfd=true"
        "androidboot.redroid_gpu_mode=host"
      ];
    };
    android2 = {
      image = "docker.io/redroid/redroid:10.0.0-latest";
      autoStart = true;
      privileged = true;
      ports = [
        "127.0.0.1:5556:5555"
      ];
      volumes = [
        "/var/lib/redroid/android2:/data:rw"
      ];
      cmd = [
        "androidboot.redroid_width=1280"
        "androidboot.redroid_height=720"
        "androidboot.redroid_dpi=160"
        "androidboot.use_memfd=true"
        "androidboot.redroid_gpu_mode=host"
      ];
    };
  };

  environment.persistence."/nix/persist".directories = [
    "/var/lib/containers"
    "/var/lib/redroid"
    "/var/lib/alas"
  ];
}
