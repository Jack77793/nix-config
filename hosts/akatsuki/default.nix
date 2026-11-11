{ config, ... }:

{
  imports = [ ./secrets.nix ];

  custom = {
    mainUser = "jack77793";
    development.enable = true;
    security.agenix.enable = true;
    stateVersion = "26.11";
  };

  networking.hostName = "Akatsuki";

  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = config.custom.mainUser;
  users.users.${config.custom.mainUser}.home = "/Users/${config.custom.mainUser}";

  system.stateVersion = 7;
}
