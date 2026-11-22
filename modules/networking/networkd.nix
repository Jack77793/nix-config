{ config, lib, ... }:

let
  useNetworkd = config.custom.hostDefaults.enable && config.custom.networking.manager == "networkd";
in
{
  config = lib.mkMerge [
    {
      assertions = [
        {
          assertion = !useNetworkd || config.systemd.network.networks != { };
          message = ''custom.networking.manager = "networkd" requires at least one systemd.network.networks unit.'';
        }
      ];
    }

    (lib.mkIf useNetworkd {
      networking.useNetworkd = true;
      systemd.network.enable = true;
    })
  ];
}
