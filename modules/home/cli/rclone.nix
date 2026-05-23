{ osConfig, lib, ... }:

lib.mkIf osConfig.custom.desktop.enable {
  programs.rclone = {
    enable = true;
  };
}
