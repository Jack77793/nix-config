{ config, ... }:

{
  programs.zsh.enable = true;

  environment.pathsToLink = [
    "/share/zsh"
  ];

  home-manager.users.${config.custom.mainUser}.imports = [
    ../../../home/modules/terminal/shell
  ];
}
