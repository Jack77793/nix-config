{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.custom.extras.gaming.enable {
  programs = {
    steam = {
      enable = true;
      protontricks.enable = true;
      extest.enable = true;
      fontPackages = with pkgs; [ sarasa-gothic ];
    };

    gamescope = {
      enable = true;
      # args = [];
    };
  };
}
