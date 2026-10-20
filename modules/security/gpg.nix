{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.custom.desktop.enable {
  home-manager.users.${config.custom.mainUser}.imports = [
    ../../home/modules/security/gpg.nix
    {
      services.gpg-agent.pinentry.package = pkgs.pinentry-gnome3;
      home.packages = [ pkgs.gcr_4 ];
    }
  ];
}
