{
  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      wireplumber.enable = true;
    };
    printing.enable = true;
  };

  hardware.bluetooth.enable = true;

  environment.persistence."/nix/persist".directories = [
    {
      directory = "/var/lib/bluetooth";
      mode = "0700";
    }
  ];
}
