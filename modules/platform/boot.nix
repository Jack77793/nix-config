{
  config,
  lib,
  pkgs,
  ...
}:

{
  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = !config.boot.lanzaboote.enable || config.custom.hostDefaults.enable;
          message = "boot.lanzaboote.enable requires custom.hostDefaults.enable.";
        }
      ];

      boot = {
        kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
        loader = {
          systemd-boot.enable = lib.mkDefault true;
          efi.canTouchEfiVariables = lib.mkDefault true;
        };
      };
    }

    (lib.mkIf config.custom.hostDefaults.enable (
      lib.mkMerge [
        {
          boot.loader = {
            systemd-boot = {
              configurationLimit = 12;
              consoleMode = "max";
            };
            timeout = 5;
          };

          console = {
            font = "Lat2-Terminus16";
            keyMap = "us";
            # useXkbConfig = true; # use xkb.options in tty.
          };
        }

        (lib.mkIf config.boot.lanzaboote.enable {
          environment.systemPackages = [ pkgs.sbctl ];

          boot = {
            loader.systemd-boot.enable = lib.mkForce false;

            lanzaboote = {
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
    ))
  ];
}
