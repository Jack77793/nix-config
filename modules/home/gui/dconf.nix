{
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      font-name = "sans-serif 12";
      document-font-name = "sans-serif 12";
      monospace-font-name = "monospace 12";
      icon-theme = "Papirus";
      clock-format = "24h";
      clock-show-seconds = true;
      clock-show-weekday = true;
      show-battery-percentage = true;
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
      titlebar-font = "sans-serif 11";
    };
    "org/gnome/nautilus/list-view".default-visible-columns = [
      "name"
      "size"
      "date_modified"
      "detailed_type"
    ];
    "org/gnome/mutter".experimental-features = [
      "scale-monitor-framebuffer"
      "xwayland-native-scaling"
    ];
  };
}
