{
  networking = {
    nftables.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [
        9000
      ];
      # allowedTCPPortRanges = [];
      # allowedUDPPorts = [];
      # allowedUDPPortRanges = [];
    };
  };
}
