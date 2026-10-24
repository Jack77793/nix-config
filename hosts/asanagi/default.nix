{
  config,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./secrets.nix
  ];

  custom = {
    profile = "desktop";

    applications.gaming.enable = true;
    security.agenix.enable = true;
    virtualization.qemu.enable = true;

    stateVersion = "25.11";
  };

  boot.lanzaboote.enable = true;
  networking.hostName = "Asanagi";

  services = {
    dae.enable = true;
    fprintd.enable = true;
    sing-box.enable = true;
    tailscale.enable = true;
  };

  virtualisation.podman.enable = true;

  home-manager.users.${config.custom.mainUser}.dconf.settings."org/gnome/mutter".experimental-features =
    [
      "scale-monitor-framebuffer"
      "xwayland-native-scaling"
    ];
}
