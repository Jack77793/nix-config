{
  lib,
  pkgs,
  osConfig,
  ...
}:

{
  imports = [
    ./packages.nix
    ./tools.nix
    ./tmux.nix
    ./shell/home.nix
  ];

  home.packages =
    lib.optionals (pkgs.stdenv.hostPlatform.isLinux && osConfig.custom.hostDefaults.enable)
      (
        with pkgs;
        [
          alsa-utils
          lm_sensors
          net-tools
          pciutils
          usbutils
          vulkan-tools
        ]
      );
}
