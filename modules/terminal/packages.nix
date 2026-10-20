{ config, pkgs, ... }:

{
  home-manager.users.${config.custom.mainUser} = {
    imports = [ ../../home/modules/terminal/packages.nix ];

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
