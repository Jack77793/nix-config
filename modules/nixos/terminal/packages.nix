{ config, pkgs, ... }:

{
  home-manager.users.${config.custom.mainUser} = {
    home.packages = with pkgs; [
      alsa-utils
      lm_sensors
      net-tools
      pciutils
      usbutils
      vulkan-tools
    ];
  };
}
