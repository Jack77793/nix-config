{ pkgs, ... }:

{
  services = {
    xserver.enable = false;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    gvfs.enable = true;
    libinput.enable = true;

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

      gdk-pixbuf
      libheif.bin
      libheif.out
      libjxl
      webp-pixbuf-loader
      ffmpeg-headless
      ffmpegthumbnailer
    ];

    pathsToLink = [
      "/share/nautilus-python/extensions"
      "share/thumbnailers"
    ];
    sessionVariables.NAUTILUS_4_EXTENSION_DIR = "/run/current-system/sw/lib/nautilus/extensions-4";
  };

  programs = {
    dconf = {
      enable = true;
      profiles.gdm.databases = [
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
    seahorse.enable = true;
    evince.enable = true;
  };

  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      anthy
      rime
    ];
  };
}
