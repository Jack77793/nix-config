{
  config,
  lib,
  pkgs,
  ...
}:

{
  virtualisation = {
    docker.enable = false;
    podman = {
      enable = config.custom.extras.virtualization.podman.enable;
      defaultNetwork.settings.dns_enabled = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
        flags = [ "--all" ];
      };
    };
  };

  environment.systemPackages = lib.optionals config.custom.extras.virtualization.qemu.enable (
    with pkgs;
    [
      qemu_kvm
    ]
  );
}
