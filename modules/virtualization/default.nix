{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.custom.virtualization = {
    qemu.enable = lib.mkEnableOption "qemu";
  };

  config = lib.mkMerge [
    { virtualisation.docker.enable = lib.mkDefault false; }

    (lib.mkIf config.virtualisation.podman.enable {
      virtualisation = {
        podman = {
          defaultNetwork.settings.dns_enabled = false;
          autoPrune = {
            enable = true;
            dates = "weekly";
            flags = [ "--all" ];
          };
        };
        containers.registries.settings = {
          registry = [
            { location = "docker.io"; }
            { location = "quay.io"; }
          ];
          unqualified-search-registries = [
            "docker.io"
            "quay.io"
          ];
        };
      };
    })

    (lib.mkIf config.custom.virtualization.qemu.enable {
      environment.systemPackages = with pkgs; [
        qemu_kvm
      ];
    })
  ];
}
