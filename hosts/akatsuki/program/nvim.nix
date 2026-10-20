{ pkgs, ... }:

{
  imports = [ ../../../home/modules/development/neovim ];

  custom.development.neovim.extended = true;
  programs.neovim.extraPackages = [ pkgs.nixfmt ];
}
