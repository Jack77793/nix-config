{
  config,
  lib,
  ...
}:

{
  options.custom.profile = lib.mkOption {
    type = lib.types.enum [
      "desktop"
      "headless"
      "sandbox"
    ];
    default = "headless";
    description = "The profile to be used";
  };

  config = lib.mkMerge [
    (lib.mkIf (config.custom.profile == "desktop") {
      custom = {
        desktop = {
          enable = lib.mkDefault true;
          gui = lib.mkDefault "gnome";
        };
        networking.manager = lib.mkDefault "nm";
        defaultUser.enable = lib.mkDefault true;
      };
    })

    (lib.mkIf (config.custom.profile == "headless") {
      custom = {
        desktop.enable = lib.mkDefault false;
        networking.manager = lib.mkDefault "networkd";
        defaultUser.enable = lib.mkDefault true;
      };
    })

    (lib.mkIf (config.custom.profile == "sandbox") {
      custom = {
        desktop.enable = lib.mkDefault false;
        hostDefaults.enable = lib.mkDefault false;
        defaultUser.enable = lib.mkDefault true;
      };
    })
  ];
}
