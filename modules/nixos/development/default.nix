{ pkgs, ... }:

{
  imports = [
    ./neovim
    ./python.nix
    ./agents
  ];

  environment.systemPackages = [ pkgs.git ];
}
