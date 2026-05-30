{ config, lib, ... }:

lib.mkIf (config.custom.networking.manager == "networkd") {
  systemd.network.enable = true;
}
