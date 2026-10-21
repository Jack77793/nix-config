{ lib, pkgs, ... }:

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

  system.activationScripts.fonts.text = lib.mkAfter ''
    ${pkgs.coreutils}/bin/touch -c "/Library/Fonts/Nix Fonts"
  '';
}
