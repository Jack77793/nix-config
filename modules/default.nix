{
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./nixos
    ./home
  ];

  config = {
    _module.args = {
      myVars = import ./vars.nix;
      myPkgs = builtins.mapAttrs (_: path: pkgs.callPackage path { }) (import ../pkgs);
    };
  };

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

    networking = {
      hostname = lib.mkOption {
        default = "";
        type = lib.types.str;
      };

      manager = lib.mkOption {
        type = lib.types.enum [
          "nm"
          "networkd"
        ];
        default = "nm";
        description = "network backend to use. when set to networkd, systemd-networkd network unit(s) must be configured per host";
      };
    };

    defaultUser.enable = lib.mkEnableOption "enable default user";
    mainUser = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "the username of main user, will be automatically set if defaultUser is set";
    };

    nvim.extended = lib.mkEnableOption "enable extended neovim";

    extras = {
      agenix.enable = lib.mkEnableOption "enable agenix";
      dae.enable = lib.mkEnableOption "enable dae";
      fingerprint.enable = lib.mkEnableOption "enable fingerprint";
      gaming.enable = lib.mkEnableOption "enable gaming related accessories";
      secureboot.enable = lib.mkEnableOption "enable secureboot";
      sing-box.enable = lib.mkEnableOption "enable sing-box";
      tailscale.enable = lib.mkEnableOption "enable tailscale";
      virtualization.enable = lib.mkEnableOption "enable virtualization";
    };
  };
}
