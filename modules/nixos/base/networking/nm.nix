{
  networking = {
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };

    wireless.iwd = {
      settings = {
        General = {
          AddressRandomization = "network";
        };
        Network = {
          NameResolvingService = "systemd";
        };
        Settings = {
          AutoConnect = true;
        };
      };
    };
  };

  environment.persistence."/nix/persist".directories = [
    {
      directory = "/var/lib/iwd";
      mode = "0700";
    }
    {
      directory = "/etc/NetworkManager/system-connections";
      mode = "0700";
    }
  ];

}
