{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.custom.desktop.enable {
  fonts = {
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
    fontDir.enable = true;
    fontconfig = {
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
    };
  };
}
