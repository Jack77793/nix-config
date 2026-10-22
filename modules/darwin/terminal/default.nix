{ config, ... }:

{
  home-manager.users.${config.custom.mainUser} =
    { config, lib, ... }:
    {
      programs = {
        ghostty.settings = {
          font-family = lib.mkForce "Sarasa Fixed SC";
          font-size = lib.mkForce 16;
          macos-titlebar-style = "tabs";
          window-theme = lib.mkForce "auto";
        };

        zsh.dotDir = lib.mkForce config.home.homeDirectory;
      };
    };
}
