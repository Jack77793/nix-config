{
  config,
  lib,
  agenix,
  pkgs,
  _class,
  ...
}:

{
  options.custom.security.agenix.enable = lib.mkEnableOption "agenix";

  config = lib.mkIf config.custom.security.agenix.enable (
    lib.mkMerge [
      {
        environment.systemPackages = [
          agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];
      }
      (lib.optionalAttrs (_class == "nixos") {
        age.identityPaths = [ "/nix/persist/etc/ssh/ssh_host_ed25519_key" ];
      })
      (lib.optionalAttrs (_class == "darwin") {
        home-manager.users.${config.custom.mainUser} =
          { config, lib, ... }:
          {
            imports = [ agenix.homeManagerModules.default ];

            home.activation.agenixLogDirectory =
              lib.hm.dag.entryBetween [ "setupLaunchAgents" ] [ "writeBoundary" ]
                ''
                  run mkdir -p ${lib.escapeShellArg "${config.home.homeDirectory}/Library/Logs/agenix"}
                '';
          };
      })
    ]
  );
}
