{ config, lib, ... }:

{
  imports = [
    ./common.nix
    ./gnome.nix
    ./fonts
    ./xdg.nix
    ./peripherals.nix
  ];

  options.custom.desktop = {
    enable = lib.mkEnableOption "gui and other related configs";
    gui = lib.mkOption {
      type = lib.types.nullOr (
        lib.types.enum [
          "gnome"
        ]
      );
      default = null;
      description = "The graphical user interface will be used";
    };
  };

  config = lib.mkIf (!config.custom.desktop.enable) {
    assertions = [
      {
        assertion = config.custom.desktop.gui == null;
        message = "desktop.gui must be null when desktop.enable is false.";
      }
    ];
  };
}
