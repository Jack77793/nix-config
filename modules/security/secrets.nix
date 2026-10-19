{
  config,
  lib,
  agenix,
  pkgs,
  ...
}:

lib.mkIf config.custom.extras.agenix.enable {
  environment.systemPackages = [
    agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  age.identityPaths = [
    "/nix/persist/etc/ssh/ssh_host_ed25519_key"
  ];
}
