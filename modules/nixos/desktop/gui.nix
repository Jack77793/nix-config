{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkMerge [
  (lib.mkIf config.custom.desktop.enable {
    services = {
      gvfs.enable = true;
      libinput.enable = true;
    };

    environment = {
      systemPackages = with pkgs; [
        gdk-pixbuf
        libheif.bin
        libheif.out
        libjxl
        webp-pixbuf-loader
        ffmpeg-headless
        ffmpegthumbnailer
      ];

      pathsToLink = [
        "share/thumbnailers"
      ];
    };

    programs = {
      dconf.enable = true;
      seahorse.enable = true;
      evince.enable = true;
    };
  })

  (lib.mkIf (config.custom.desktop.enable && config.custom.desktop.gui == "gnome") {
    services = {
      xserver.enable = false;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;

      gnome = {
        sushi.enable = true;
        core-apps.enable = false;
        core-developer-tools.enable = false;
        games.enable = false;
      };
    };

    environment = {
      gnome.excludePackages = with pkgs; [
        gnome-tour
        gnome-user-docs
      ];
      systemPackages = with pkgs; [
        nautilus
        nautilus-python
      ];

      pathsToLink = [
        "/share/nautilus-python/extensions"
      ];
      sessionVariables.NAUTILUS_4_EXTENSION_DIR = "/run/current-system/sw/lib/nautilus/extensions-4";
    };

    programs = {
      dconf.profiles.gdm.databases = [
        {
          settings."org/gnome/desktop/interface" = {
            clock-format = "24h";
            clock-show-seconds = true;
            clock-show-weekday = true;
            show-battery-percentage = true;
            font-name = "sans-serif 12";
          };
        }
      ];
    };

    i18n.inputMethod = {
      enable = true;
      type = "ibus";
      ibus.engines = with pkgs.ibus-engines; [
        anthy
        rime
      ];
    };

    networking.firewall = {
      allowedTCPPorts = [
        53317
      ];
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
    };
  })
]
