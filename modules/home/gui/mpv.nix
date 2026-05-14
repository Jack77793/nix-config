{ pkgs, ... }:

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
      hwdec = "vaapi-copy";
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
      vo = "dmabuf-wayland";
      volume-max = 100;
      video-sync = "display-resample";
      ytdl-raw-options = "cookies-from-browser=chromium";
    };
    scripts = with pkgs.mpvScripts; [
      mpris
      uosc
      thumbfast
    ];
  };
}
