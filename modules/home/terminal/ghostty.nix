{ lib, pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    package = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (lib.mkDefault null);
    settings = {
      bold-color = "bright";
      font-family = "monospace";
      font-size = 15;
      shell-integration-features = "no-ssh-terminfo";
      theme = "Nord";
      window-theme = "ghostty";
      window-height = 36;
      window-width = 128;
    }
    // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
      gtk-single-instance = false;
    };
  };
}
