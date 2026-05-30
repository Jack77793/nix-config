{
  config,
  ...
}:

{
  imports = [ ./hardware-configuration.nix ];

  custom = {
    networking = {
      hostname = "Asanagi";
      manager = "nm";
    };

    desktop = {
      enable = true;
      gui = "gnome";
    };

    defaultUser.enable = true;

    extras = {
      agenix.enable = true;
      dae.enable = true;
      fingerprint.enable = true;
      secureboot.enable = true;
      sing-box.enable = true;
      tailscale.enable = true;
      virtualization.enable = true;
    };
  };

  home-manager.users.${config.custom.mainUser}.home.stateVersion = "25.11";
  system.stateVersion = "25.11"; # Did you read the comment?
}
