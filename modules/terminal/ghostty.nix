{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = config.programs.zsh.enable;
    package = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (lib.mkDefault null);
    settings = lib.mkMerge [
      (lib.mapAttrs (_: lib.mkDefault) {
        bold-color = "bright";
        shell-integration-features = "no-ssh-terminfo";
        theme = "Nord";
        window-height = 36;
        window-width = 128;
      })
      (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (
        lib.mapAttrs (_: lib.mkDefault) {
          font-family = "Sarasa Fixed SC";
          font-size = 16;
          macos-titlebar-style = "tabs";
          window-theme = "auto";
        }
      ))
      (lib.mkIf (!pkgs.stdenv.hostPlatform.isDarwin) (
        lib.mapAttrs (_: lib.mkDefault) {
          font-family = "monospace";
          font-size = 15;
          gtk-single-instance = false;
          window-theme = "ghostty";
        }
      ))
    ];
  };
}
