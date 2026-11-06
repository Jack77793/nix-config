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
    {
      custom = {
        defaultUser.enable = lib.mkDefault true;
        desktop.enable = lib.mkDefault (config.custom.profile == "desktop");
      };
    }
    (lib.mkIf (config.custom.profile == "desktop") {
      custom = {
        desktop.gui = lib.mkDefault "gnome";
        networking.manager = lib.mkDefault "nm";
      };
    })

    (lib.mkIf (config.custom.profile == "headless") {
      custom.networking.manager = lib.mkDefault "networkd";
    })

    (lib.mkIf (config.custom.profile == "sandbox") {
      custom.hostDefaults.enable = lib.mkDefault false;
    })
  ];
}
