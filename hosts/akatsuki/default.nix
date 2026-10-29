let
  username = "jack77793";
  homeDirectory = "/Users/${username}";
in
{
  imports = [ ./secrets.nix ];

  custom = {
    development.enable = true;
    security.agenix.enable = true;
  };

  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = username;
  users.users.${username}.home = homeDirectory;

  system.stateVersion = 7;

  home-manager.users.${username}.home.stateVersion = "26.11";
}
