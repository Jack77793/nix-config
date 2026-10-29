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
    settings = lib.mapAttrs (_: lib.mkDefault) (
      {
        bold-color = "bright";
        font-family = "monospace";
        font-size = 15;
        shell-integration-features = "no-ssh-terminfo";
        theme = "Nord";
        window-theme = "ghostty";
        window-height = 36;
        window-width = 128;
      }
      // (
        if pkgs.stdenv.hostPlatform.isDarwin then
          {
            font-family = "Sarasa Fixed SC";
            font-size = 16;
            macos-titlebar-style = "tabs";
            window-theme = "auto";
          }
        else
          {
            gtk-single-instance = false;
          }
      )
    );
  };
}
