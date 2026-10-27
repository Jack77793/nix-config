{
  config,
  lib,
  pkgs,
  _class,
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
      fonts.packages = with pkgs; [
        iosevka
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
      ];
    }
    (
      if _class == "nixos" then
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

          home-manager.users.${config.custom.mainUser}.fonts.fontconfig = {
            inherit defaultFonts;
            enable = true;
            configFile = {
              mappings = {
                enable = true;
                priority = 80;
                source = ./config/mappings.conf;
              };
              steam = lib.mkIf config.custom.applications.gaming.enable {
                enable = true;
                priority = 75;
                source = ./config/steam.conf;
              };
            };
          };
        }
      else
        {
          system.activationScripts.fonts.text = lib.mkAfter ''
            ${pkgs.coreutils}/bin/touch -c "/Library/Fonts/Nix Fonts"
          '';
        }
    )
  ]
)
