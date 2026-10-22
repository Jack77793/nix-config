{ lib, ... }:

{
  services.mpd = {
    enable = true;
    extraConfig = lib.mkBefore ''
      restore_paused "yes"
      auto_update "yes"
      replaygain "track"
      replaygain_preamp "0"
      replaygain_missing_preamp "0"
      filesystem_charset "UTF-8"
    '';
  };
}
