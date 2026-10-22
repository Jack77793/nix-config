{ pkgs, ... }:

{
  imports = [
    ./python.nix
    ./agents
  ];

  environment.systemPackages = [ pkgs.git ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
}
