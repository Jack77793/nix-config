{ config, lib, ... }:

lib.mkIf config.custom.desktop.enable {
  home-manager.users.${config.custom.mainUser}.imports = [
    {
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
  ];
}
