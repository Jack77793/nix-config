{
  lib,
  ...
}:

{
  imports = [
    ./nixos
    ./home
  ];

  options.custom = {
    desktop = {
      enable = lib.mkEnableOption "enable gui and other related configs";
      gui = lib.mkOption {
        type = lib.types.enum [
          ""
          "gnome"
        ];
        default = "";
        description = "the graphical user interface will be used";
      };
    };

    hostname = lib.mkOption {
      default = "";
      type = lib.types.str;
    };

    defaultUser.enable = lib.mkEnableOption "enable default user";
    dae.enable = lib.mkEnableOption "enable dae";
    virtualization.enable = lib.mkEnableOption "enable virtualization";
  };
}
