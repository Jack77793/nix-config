{ pkgs, ... }:

{
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
