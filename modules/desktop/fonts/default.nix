{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.custom.desktop.enable (
  lib.mkMerge [
    {
      fonts = {
        enableDefaultPackages = false;
        fontDir.enable = true;
        fontconfig = {
          defaultFonts = {
            emoji = [
              "Noto Color Emoji"
            ];
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
          enable = true;
        };
        packages = with pkgs; [
          arphic-ukai
          iosevka
          lmodern
          nerd-fonts.iosevka-term
          (noto-fonts.overrideAttrs (old: {
            postPatch = (old.postPatch or "") + ''
              rm -rf fonts/*/unhinted/variable-ttf
            '';
          }))
          noto-fonts-cjk-sans-static
          noto-fonts-cjk-serif-static
          noto-fonts-color-emoji
          sarasa-gothic
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
            defaultFonts = {
              emoji = [
                "Noto Color Emoji"
              ];
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
            enable = true;
          };
        }
      ];
    }

    (lib.mkIf config.custom.extras.gaming.enable {
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
