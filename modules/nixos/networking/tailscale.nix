{ config, lib, ... }:

{
  config = lib.mkIf config.services.tailscale.enable {
    services.tailscale = {
      interfaceName = "tailscale0";
      openFirewall = true;
    };

    networking.firewall = {
      trustedInterfaces = [ "tailscale0" ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };

    systemd.services.tailscaled.serviceConfig.Environment = [
      "TS_DEBUG_FIREWALL_MODE=nftables"
    ];

    environment.persistence."/nix/persist".directories = [
      "/var/lib/tailscale"
    ];
  };
}
