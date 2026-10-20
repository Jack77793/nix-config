{ config, ... }:

{
  home-manager.users.${config.custom.mainUser}.imports = [
    ../../home/modules/terminal/tmux.nix
  ];
}
