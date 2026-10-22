{
  config,
  lib,
  pkgs,
  ...
}:

let
  defaultFonts = {
    emoji = [ "Noto Color Emoji" ];
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
  };
in
lib.mkIf config.custom.desktop.enable (
  lib.mkMerge [
    {
      fonts = {
        enableDefaultPackages = false;
        fontDir.enable = true;
        fontconfig = {
          inherit defaultFonts;
          enable = true;
        };
        packages = with pkgs; [
          arphic-ukai
          lmodern
          source-han-sans
          source-han-serif
        ];
      };

      home-manager.users.${config.custom.mainUser}.imports = [
        {
          fonts.fontconfig = {
            configFile.mappings = {
              enable = true;
              priority = 80;
              source = ./config/mappings.conf;
            };
            inherit defaultFonts;
            enable = true;
          };
        }
      ];
    }

    (lib.mkIf config.custom.applications.gaming.enable {
      home-manager.users.${config.custom.mainUser}.imports = [
        {
          fonts.fontconfig.configFile.steam = {
            enable = true;
            priority = 75;
            source = ./config/steam.conf;
          };
        }
      ];
    })
  ]
)
