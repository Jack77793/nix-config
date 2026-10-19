{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkMerge [
  {
    boot = {
      kernelPackages = pkgs.linuxPackages_latest;
      loader = {
        systemd-boot = {
          enable = true;
          configurationLimit = 12;
          consoleMode = "max";
        };
        timeout = 5;
        efi.canTouchEfiVariables = true;
      };
    };

    console = {
      font = "Lat2-Terminus16";
      keyMap = "us";
      # useXkbConfig = true; # use xkb.options in tty.
    };
  }

  (lib.mkIf config.custom.extras.secureboot.enable {
    environment.systemPackages = [ pkgs.sbctl ];

    boot = {
      loader.systemd-boot.enable = lib.mkForce false;

      lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };
    };

    environment.persistence."/nix/persist".directories = [
      {
        directory = "/var/lib/sbctl";
        mode = "0700";
      }
    ];
  })
]
