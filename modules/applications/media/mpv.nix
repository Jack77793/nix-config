{ lib, pkgs, ... }:

{
  programs.mpv = {
    enable = true;
    config = lib.mkMerge [
      {
        audio-pitch-correction = true;
        cache = true;
        cache-on-disk = false;
        cache-secs = 300;
        cscale = "ewa_lanczossharp";
        embeddedfonts = false;
        icc-profile-auto = true;
        interpolation = true;
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
      (lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
        hwdec = "videotoolbox";
        ytdl-raw-options = "cookies-from-browser=chrome";
      })
      (lib.mkIf (pkgs.stdenv.hostPlatform.isLinux) {
        border = true;
        hwdec = "vaapi";
        osd-bar = false;
        vo = "dmabuf-wayland";
        ytdl-raw-options = "cookies-from-browser=chromium";
      })
    ];
    scripts =
      with pkgs.mpvScripts;
      lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        mpris
        thumbfast
        uosc
      ];
  };
}
