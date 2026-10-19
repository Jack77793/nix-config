{ config, lib, ... }:

{
  config = lib.mkIf config.services.fprintd.enable {
    environment.persistence."/nix/persist".directories = [
      "/var/lib/fprint"
    ];
  };
}
