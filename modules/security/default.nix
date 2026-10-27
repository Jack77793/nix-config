{
  config,
  lib,
  pkgs,
  _class,
  ...
}:

{
  imports = lib.optionals (_class == "nixos") [
    ./secrets.nix
    ./fingerprint.nix
    ./keepassxc.nix
  ];

  config = lib.mkMerge [
    (lib.mkIf config.custom.desktop.enable {
      home-manager.users.${config.custom.mainUser} = {
        imports = [ ./gpg.nix ];
      }
      // lib.optionalAttrs (_class == "nixos") {
        services.gpg-agent.pinentry.package = pkgs.pinentry-gnome3;
        home.packages = [ pkgs.gcr_4 ];
      };
    })
    (lib.optionalAttrs (_class == "darwin") {
      security.pam.services.sudo_local.touchIdAuth = true;
    })
  ];
}
