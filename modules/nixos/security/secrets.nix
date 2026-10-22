{
  config,
  lib,
  agenix,
  pkgs,
  ...
}:

{
  options.custom.security.agenix.enable = lib.mkEnableOption "agenix";

  config = lib.mkIf config.custom.security.agenix.enable {
    environment.systemPackages = [
      agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    age.identityPaths = [
      "/nix/persist/etc/ssh/ssh_host_ed25519_key"
    ];
  };
}
