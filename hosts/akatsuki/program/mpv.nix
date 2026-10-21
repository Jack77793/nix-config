{
  imports = [ ../../../home/modules/applications/mpv.nix ];

  programs.mpv.config = {
    hwdec = "videotoolbox";
    vo = "gpu-next";
    ytdl-raw-options = "cookies-from-browser=chrome";
  };
}
