{ config, lib, ... }:

lib.mkIf config.custom.hostDefaults.enable {
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    settings.publish = {
      publish-domain = true;
      disable-publishing = false;
      disable-user-service-publishing = false;
      publish-addresses = true;
    };
  };
}
