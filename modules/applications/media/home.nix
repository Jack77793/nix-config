{ lib, pkgs, ... }:

{
  imports = [
    ./mpv.nix
    ./mpd.nix
    ./mpd-now-playable.nix
    ./ncmpcpp.nix
    ./cava.nix
  ];

  home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.soundfont-fluid ];

  programs.obs-studio.enable = pkgs.stdenv.hostPlatform.isLinux;

  services = {
    fluidsynth = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
      enable = true;
      extraOptions = [ "--sample-rate 48000" ];
      soundFont = "${pkgs.soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2";
      soundService = "pipewire-pulse";
    };
    mpd-mpris.enable = pkgs.stdenv.hostPlatform.isLinux;
  };
}
