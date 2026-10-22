{ config, ... }:

{
  home-manager.users.${config.custom.mainUser} =
    { config, ... }:
    {
      programs = {
        ghostty.settings = {
          font-family = "Sarasa Fixed SC";
          font-size = 16;
          macos-titlebar-style = "tabs";
          window-theme = "auto";
        };

        zsh.dotDir = config.home.homeDirectory;
      };
    };
}
