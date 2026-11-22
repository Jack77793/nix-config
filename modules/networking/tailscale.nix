{ config, lib, ... }:

{
  config = lib.mkIf config.services.tailscale.enable {
    services.tailscale.openFirewall = true;

    networking.firewall.trustedInterfaces = [ config.services.tailscale.interfaceName ];

    systemd.services.tailscaled.serviceConfig.Environment = [
      "TS_DEBUG_FIREWALL_MODE=nftables"
    ];

    environment.persistence."/nix/persist".directories = [
      "/var/lib/tailscale"
    ];
  };
}
