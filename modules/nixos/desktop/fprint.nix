{ config, lib, ... }:

lib.mkIf config.custom.desktop.enable {
  services.fprintd = {
    enable = true;
  };

  environment.persistence."/nix/persist".directories = [
    "/var/lib/fprint"
  ];
}
