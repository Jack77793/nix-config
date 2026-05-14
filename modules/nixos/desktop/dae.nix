{ config, ... }:

{
  services.dae = {
    enable = true;
    configFile = config.age.secrets."config.dae".path;
  };
}
