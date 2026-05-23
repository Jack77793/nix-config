{ osConfig, lib, ... }:

lib.mkIf osConfig.custom.desktop.enable {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      bold-color = "bright";
      font-family = "monospace";
      font-size = 15;
      gtk-single-instance = false;
      shell-integration-features = true;
      theme = "Nord";
      window-theme = "ghostty";
      window-height = 36;
      window-width = 128;
    };
  };
}
