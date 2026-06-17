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
      virtualization.enable = true;
    };
  };

  home-manager.users.${config.custom.mainUser}.home.stateVersion = "25.11";
  system.stateVersion = "25.11"; # Did you read the comment?
}
