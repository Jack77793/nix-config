{ osConfig, lib, ... }:

lib.mkIf osConfig.custom.desktop.enable {
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [
        "Sarasa Fixed SC"
        "Sarasa Fixed TC"
        "Sarasa Fixed J"
        "Sarasa Fixed K"
        "IosevkaTerm Nerd Font"
      ];
      sansSerif = [
        "Sarasa Fixed SC"
        "Sarasa Fixed TC"
        "Sarasa Fixed J"
        "Sarasa Fixed K"
        "Noto Sans"
      ];
      serif = [
        "Noto Serif CJK SC"
        "Noto Serif CJK TC"
        "Noto Serif CJK JP"
        "Noto Serif CJK KR"
        "Noto Serif"
      ];
      emoji = [
        "Noto Color Emoji"
      ];
    };
    configFile = {
      steam = {
        enable = true;
        priority = 75;
        source = ./config/steam.conf;
      };
      mappings = {
        enable = true;
        priority = 80;
        source = ./config/mappings.conf;
      };
    };
  };
}
