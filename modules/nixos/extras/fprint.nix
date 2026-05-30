{ config, lib, ... }:

lib.mkIf config.custom.extras.fingerprint.enable {
  services.fprintd = {
    enable = true;
  };

  environment.persistence."/nix/persist".directories = [
    "/var/lib/fprint"
  ];
}
