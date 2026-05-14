{ pkgs, ... }:

{
  services.fluidsynth = {
    enable = true;
    extraOptions = [ "--sample-rate 48000" ];
    soundFont = "${pkgs.soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2";
    soundService = "pipewire-pulse";
  };

  home.packages = with pkgs; [ soundfont-fluid ];
}
