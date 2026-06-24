{
  config,
  lib,
  ...
}:

{
  imports = [
    ./nixos
    ./home
  ];

  config = lib.mkMerge [
    {
      _module.args = {
        myVars = import ./vars.nix;
      };
      nixpkgs.overlays = (import ../pkgs);
      system.stateVersion = config.custom.stateVersion;
    }

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

    (lib.mkIf (!config.custom.desktop.enable) {
      assertions = [
        {
          assertion = config.custom.desktop.gui == null;
          message = "desktop.gui must be null when desktop.enable is false.";
        }
      ];
    })

    (lib.mkIf config.custom.extras.gaming.enable {
      assertions = [
        {
          assertion = config.custom.desktop.enable;
          message = "Gaming option cannot be enabled without desktop enabled.";
        }
      ];
    })
  ];

  options.custom = {
    desktop = {
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

    profile = lib.mkOption {
      type = lib.types.enum [
        "desktop"
        "headless"
      ];
      default = "headless";
      description = "The profile to be used";
    };

    stateVersion = lib.mkOption {
      default = "";
      type = lib.types.str;
      description = "The state version of host, will be applied to system and home-manager";
    };
  };
}
