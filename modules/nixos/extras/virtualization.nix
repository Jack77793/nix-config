{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkMerge [
  { virtualisation.docker.enable = false; }

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
]
