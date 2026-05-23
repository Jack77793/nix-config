{
  osConfig,
  lib,
  pkgs,
  ...
}:

lib.mkIf osConfig.custom.desktop.enable {
  programs.obs-studio = {
    enable = true;
    # plugins = with pkgs.obs-studio-plugins; [ wlrobs ];
  };
}
