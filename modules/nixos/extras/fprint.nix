{ config, lib, ... }:

lib.mkIf config.custom.fingerprint.enable {
  services.fprintd = {
    enable = true;
  };

  environment.persistence."/nix/persist".directories = [
    "/var/lib/fprint"
  ];
}
