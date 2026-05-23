{ osConfig, lib, ... }:

lib.mkIf osConfig.custom.desktop.enable {
  programs.keepassxc = {
    enable = true;
    settings = {
      Browser.Enabled = true;
      GUI = {
        ApplicationTheme = "classic";
        Language = "zh_CN";
        MinimizeOnClose = true;
        MinimizeToTray = false;
        ShowTrayIcon = true;
        TrayIconAppearance = "monochrome-light";
      };
    };
  };
}
