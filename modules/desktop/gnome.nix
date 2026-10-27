{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf (config.custom.desktop.gui == "gnome") {
  environment = {
    gnome.excludePackages = with pkgs; [
      gnome-tour
      gnome-user-docs
    ];
    pathsToLink = [
      "/share/nautilus-python/extensions"
    ];
    sessionVariables = {
      GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" [
        pkgs.gst_all_1.gst-plugins-good
        pkgs.gst_all_1.gst-plugins-bad
        pkgs.gst_all_1.gst-plugins-ugly
        pkgs.gst_all_1.gst-libav
      ];
      NAUTILUS_4_EXTENSION_DIR = "/run/current-system/sw/lib/nautilus/extensions-4";
    };
    systemPackages = with pkgs; [
      nautilus
      nautilus-python
      papers
    ];
  };

  home-manager.users.${config.custom.mainUser} = {
    home = {
      packages = with pkgs; [
        citations
        decibels
        endeavour
        fractal
        gnome-calendar
        gnome-characters
        gnome-clocks
        gnome-logs
        gnome-shell-extensions
        gnome-sound-recorder
        gnome-system-monitor
        gnome-weather
        loupe
        newsflash
        papirus-icon-theme
        resources
        snapshot
        tangram
      ];
      pointerCursor = {
        enable = true;
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
        size = 32;
      };
    };

    programs.gnome-shell = {
      enable = true;
      extensions = [
        { package = pkgs.gnomeExtensions.appindicator; }
        { package = pkgs.gnomeExtensions.alphabetical-app-grid; }
        { package = pkgs.gnomeExtensions.caffeine; }
        { package = pkgs.gnomeExtensions.clipboard-indicator; }
        { package = pkgs.gnomeExtensions.gsconnect; }
      ];
    };

    qt = {
      enable = true;
      kvantum = {
        enable = true;
        settings = {
          General.theme = "KvArc";
        };
      };
      platformTheme.name = "adwaita";
      style.name = "kvantum";
    };

    services = {
      gnome-keyring.enable = true;
      mpris-proxy.enable = true;
    };
  };

  i18n.inputMethod = {
    enable = true;
    ibus.engines = with pkgs.ibus-engines; [
      anthy
      rime
    ];
    type = "ibus";
  };

  networking.firewall = {
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedTCPPorts = [
      53317
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
  };

  programs.dconf.profiles.gdm.databases = [
    {
      settings."org/gnome/desktop/interface" = {
        clock-format = "24h";
        clock-show-seconds = true;
        clock-show-weekday = true;
        font-name = "sans-serif 12";
        show-battery-percentage = true;
      };
    }
  ];

  services = {
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
    gnome = {
      core-apps.enable = false;
      core-developer-tools.enable = false;
      games.enable = false;
      sushi.enable = true;
    };
    xserver.enable = false;
  };
}
