{ pkgs, ... }:

{
  virtualisation = {
    docker.enable = false;
    podman = {
      enable = true;
      defaultNetwork.settings.dns_enabled = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = [ "--all" ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    qemu_kvm
  ];
}
