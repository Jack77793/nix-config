{ home-manager, ... }:

let
  username = "jack77793";
  homeDirectory = "/Users/${username}";
in
{
  imports = [
    home-manager.darwinModules.home-manager
    ./font.nix
    ./nix.nix
    ./packages.nix
  ];

  system.primaryUser = username;
  users.users.${username}.home = homeDirectory;

  system.stateVersion = 7;

  security.pam.services.sudo_local.touchIdAuth = true;

  programs.zsh.enable = true;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.${username} = {
      imports = [ ./program ];

      programs.home-manager.enable = true;

      home = {
        inherit username homeDirectory;
        stateVersion = "26.11";
      };
    };
  };
}
