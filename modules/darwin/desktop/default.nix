{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.custom.desktop.enable {
  system.activationScripts.fonts.text = lib.mkAfter ''
    ${pkgs.coreutils}/bin/touch -c "/Library/Fonts/Nix Fonts"
  '';
}
