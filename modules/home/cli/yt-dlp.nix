{ osConfig, lib, ... }:

lib.mkIf osConfig.custom.desktop.enable {
  programs.yt-dlp = {
    enable = true;
    settings = {
      downloader = "aria2c";
      downloader-args = "aria2c:'-c -x16 -s16 -k1M'";
    };
  };
}
