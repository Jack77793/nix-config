{
  config,
  ...
}:

{
  imports = [ ./hardware-configuration.nix ];

  custom = {
    profile = "desktop";

    networking.hostname = "Asanagi";

    extras = {
      agenix.enable = true;
      dae.enable = true;
      fingerprint.enable = true;
      gaming.enable = true;
      secureboot.enable = true;
      sing-box.enable = true;
      tailscale.enable = true;
      virtualization = {
        podman.enable = true;
        qemu.enable = true;
      };
    };

    stateVersion = "25.11";
  };

  home-manager.users.${config.custom.mainUser}.dconf.settings."org/gnome/mutter".experimental-features =
    [
      "scale-monitor-framebuffer"
      "xwayland-native-scaling"
    ];
}
