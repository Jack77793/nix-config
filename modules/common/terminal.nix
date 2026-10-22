{ config, lib, ... }:

{
  programs.zsh.enable = true;

  home-manager.users.${config.custom.mainUser} = {
    imports = [
      ../home/terminal/packages.nix
      ../home/terminal/tools.nix
      ../home/terminal/tmux.nix
      ../home/terminal/shell
    ]
    ++ lib.optional config.custom.desktop.enable ../home/terminal/ghostty.nix;

    programs.ripgrep-all.enable = config.custom.desktop.enable;
  };
}
