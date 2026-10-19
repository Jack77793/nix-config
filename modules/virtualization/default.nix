{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.custom.extras.virtualization = {
    podman.enable = lib.mkEnableOption "podman";
    qemu.enable = lib.mkEnableOption "qemu";
  };

  config = lib.mkMerge [
    { virtualisation.docker.enable = lib.mkDefault false; }

    (lib.mkIf config.custom.extras.virtualization.podman.enable {
      virtualisation = {
        podman = {
          enable = config.custom.extras.virtualization.podman.enable;
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
        oci-containers.backend = "podman";
      };
    })

    (lib.mkIf config.custom.extras.virtualization.qemu.enable {
      environment.systemPackages = with pkgs; [
        qemu_kvm
      ];
    })
  ];
}
