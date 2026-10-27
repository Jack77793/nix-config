{ lib, pkgs, ... }:

{
  programs.mpv = {
    enable = true;
    config = {
      audio-pitch-correction = true;
      border = true;
      cache = true;
      cache-on-disk = false;
      cache-secs = 300;
      cscale = "ewa_lanczossharp";
      embeddedfonts = false;
      icc-profile-auto = true;
      interpolation = true;
      osd-bar = false;
      profile = "high-quality";
      scale = "ewa_lanczossharp";
      screenshot-format = "png";
      sub-ass-style-overrides = "FontName=sans-serif";
      sub-auto = "fuzzy";
      tscale = "oversample";
      vf = "lavfi=\"fps=fps=60:round=down\"";
      video-sync = "display-resample";
      volume-max = 100;
    }
    // (
      if pkgs.stdenv.hostPlatform.isDarwin then
        {
          hwdec = "videotoolbox";
          vo = "gpu-next";
          ytdl-raw-options = "cookies-from-browser=chrome";
        }
      else
        {
          hwdec = "vaapi";
          vo = "dmabuf-wayland";
          ytdl-raw-options = "cookies-from-browser=chromium";
        }
    );
    scripts =
      with pkgs.mpvScripts;
      [
        uosc
        thumbfast
      ]
      ++ lib.optional pkgs.stdenv.hostPlatform.isLinux mpris;
  };
}
