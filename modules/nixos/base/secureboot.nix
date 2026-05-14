{
  lanzaboote,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    lanzaboote.nixosModules.lanzaboote
  ];

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
