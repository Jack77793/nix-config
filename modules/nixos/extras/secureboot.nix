{
  config,
  pkgs,
  lib,
  ...
}:

lib.mkIf config.custom.secureboot.enable {
  environment.systemPackages = [ pkgs.sbctl ];

  boot = {
    loader.systemd-boot.enable = lib.mkForce false;

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };

  environment.persistence."/nix/persist".directories = [
    {
      directory = "/var/lib/sbctl";
      mode = "0700";
    }
  ];
}
