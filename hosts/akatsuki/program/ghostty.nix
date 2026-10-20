{ lib, ... }:

{
  imports = [ ../../../home/modules/terminal/ghostty.nix ];

  programs.ghostty.settings = {
    font-family = lib.mkForce "Sarasa Fixed SC";
    font-size = lib.mkForce 16;
    macos-titlebar-style = "tabs";
    shell-integration-features = lib.mkForce "no-ssh-terminfo";
    window-theme = lib.mkForce "auto";
  };
}
