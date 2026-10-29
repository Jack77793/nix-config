{ config, lib, ... }:

lib.mkIf (config.custom.hostDefaults.enable && config.custom.networking.manager == "networkd") {
  networking.useNetworkd = true;
  systemd.network.enable = true;
}
