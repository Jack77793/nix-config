{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.custom.extras.virtualization.enable {
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
