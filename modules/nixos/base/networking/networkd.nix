{ config, lib, ... }:

lib.mkIf (config.custom.networking.manager == "networkd") {
  networking.useNetworkd = true;
  systemd.network.enable = true;
}
