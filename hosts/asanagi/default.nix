{
  myVars,
  ...
}:

{
  imports = [ ./hardware-configuration.nix ];

  custom = {
    hostname = "Asanagi";

    desktop = {
      enable = true;
      gui = "gnome";
    };

    defaultUser.enable = true;

    agenix.enable = true;
    dae.enable = true;
    fingerprint.enable = true;
    secureboot.enable = true;
    sing-box.enable = true;
    tailscale.enable = true;
    virtualization.enable = true;
  };

  home-manager.users.${myVars.username}.home.stateVersion = "25.11";
  system.stateVersion = "25.11"; # Did you read the comment?
}
