{
  services.fwupd = {
    enable = true;
  };

  environment.persistence."/nix/persist".directories = [
    "/var/lib/fwupd"
  ];
}
