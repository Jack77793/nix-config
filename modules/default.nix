{
  lib,
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
    };
    nixpkgs.overlays = (import ../pkgs);
  };

  options.custom = {
    desktop = {
      enable = lib.mkEnableOption "gui and other related configs";
      gui = lib.mkOption {
        type = lib.types.enum [
          "gnome"
        ];
        default = "gnome";
        description = "The graphical user interface will be used";
      };
    };

    networking = {
      hostname = lib.mkOption {
        default = "";
        type = lib.types.str;
        description = "Hostname of the machine";
      };

      manager = lib.mkOption {
        type = lib.types.enum [
          "nm"
          "networkd"
        ];
        default = "nm";
        description = "The network backend to use. when set to networkd, systemd-networkd network unit(s) must be configured per host";
      };
    };

    defaultUser.enable = lib.mkEnableOption "default user";
    mainUser = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "The username of main user, will be automatically set if defaultUser is set";
    };

    nvim.extended = lib.mkEnableOption "extended neovim";

    extras = {
      agenix.enable = lib.mkEnableOption "agenix";
      dae.enable = lib.mkEnableOption "dae";
      fingerprint.enable = lib.mkEnableOption "fingerprint";
      gaming.enable = lib.mkEnableOption "gaming related accessories";
      secureboot.enable = lib.mkEnableOption "secureboot";
      sing-box.enable = lib.mkEnableOption "sing-box";
      tailscale.enable = lib.mkEnableOption "tailscale";
      virtualization.enable = lib.mkEnableOption "virtualization";
    };
  };
}
