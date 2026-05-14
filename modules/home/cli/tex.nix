{ pkgs, ... }:

{
  programs.pandoc.enable = true;

  home.packages = with pkgs; [
    texliveFull
  ];
}
