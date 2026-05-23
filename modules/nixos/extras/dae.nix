{ config, lib, ... }:

lib.mkIf config.custom.dae.enable {
  services.dae = {
    enable = true;
    configFile = config.age.secrets."config.dae".path;
  };
}
