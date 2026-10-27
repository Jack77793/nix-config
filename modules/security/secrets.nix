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
    {
      environment.systemPackages = [
        agenix.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    }
    // (
      if _class == "nixos" then
        {
          age.identityPaths = [ "/nix/persist/etc/ssh/ssh_host_ed25519_key" ];
        }
      else
        {
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
        }
    )
  );
}
