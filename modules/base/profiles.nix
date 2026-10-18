{
  config,
  lib,
  ...
}:

lib.mkMerge [
  (lib.mkIf (config.custom.profile == "desktop") {
    custom = {
      desktop = {
        enable = lib.mkDefault true;
        gui = lib.mkDefault "gnome";
      };
      networking.manager = lib.mkDefault "nm";
      defaultUser.enable = lib.mkDefault true;
      nvim.extended = lib.mkDefault true;
    };
  })

  (lib.mkIf (config.custom.profile == "headless") {
    custom = {
      desktop.enable = lib.mkDefault false;
      networking.manager = lib.mkDefault "networkd";
      defaultUser.enable = lib.mkDefault true;
      nvim.extended = lib.mkDefault false;
    };
  })
]
