{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.custom.desktop.enable {
  services = {
    gvfs.enable = true;
    libinput.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      ffmpeg-headless
      ffmpegthumbnailer
      gdk-pixbuf
      libavif
      libheif
      libheif.out
      libjxl
      webp-pixbuf-loader
    ];

    pathsToLink = [
      "share/thumbnailers"
    ];
  };

  programs = {
    dconf.enable = true;
    seahorse.enable = true;
  };
}
