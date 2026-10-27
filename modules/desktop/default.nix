{
  config,
  lib,
  _class,
  ...
}:

{
  imports = [
    ./fonts
  ]
  ++ lib.optionals (_class == "nixos") [
    ./common.nix
    ./gnome.nix
    ./xdg.nix
    ./peripherals.nix
  ];

  options.custom.desktop = {
    enable = lib.mkEnableOption "desktop applications and related configuration" // {
      default = _class == "darwin";
    };
  }
  // lib.optionalAttrs (_class == "nixos") {
    gui = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "gnome" ]);
      default = null;
      description = "The graphical user interface will be used";
    };
  };

  config = lib.optionalAttrs (_class == "nixos") {
    assertions = [
      {
        assertion = config.custom.desktop.enable || config.custom.desktop.gui == null;
        message = "desktop.gui must be null when desktop.enable is false.";
      }
    ];
  };
}
