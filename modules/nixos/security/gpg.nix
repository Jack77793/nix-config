{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.custom.desktop.enable {
  home-manager.users.${config.custom.mainUser} = {
    services.gpg-agent.pinentry.package = pkgs.pinentry-gnome3;
    home.packages = [ pkgs.gcr_4 ];
  };
}
