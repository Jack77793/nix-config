{
  config,
  lib,
  pkgs,
  home-manager,
  ...
}:

let
  hostUser = config.custom.mainUser;
  hostHome = config.users.users.${hostUser}.home;
  hostPi = rec {
    configDir = config.home-manager.users.${hostUser}.programs.pi-coding-agent.configDir;
    stateDir = dirOf configDir;
    sessionsDir = "${stateDir}/pi-sandboxed-sessions";
    authDir = "${stateDir}/pi-sandboxed-auth";
    secrets = {
      inherit (config.age.secrets) gemini deepseek;
    };
  };

  guestPi = {
    sessionsDir = "/var/lib/pi-sandboxed-sessions";
    authDir = "/var/lib/pi-sandboxed-auth";
    packagesDir = "/var/lib/pi-host-packages";
    secretsDir = "/run/pi-sandboxed-secrets";
  };

  piPackageDirs = [
    "npm"
    "git"
  ];
in
{
  options.custom.development.agentSandbox.enable = lib.mkEnableOption "sandbox for coding agents";

  config = lib.mkIf config.custom.development.agentSandbox.enable {
    systemd.tmpfiles.rules = map (path: "d ${path} 0700 ${hostUser} users - -") [
      hostPi.sessionsDir
      hostPi.authDir
    ];

    home-manager.users.${hostUser} =
      { lib, ... }:
      {
        home.activation.piSandboxPackageDirs = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
          run mkdir -p -m 0700 -- ${
            lib.escapeShellArgs (map (dir: "${hostPi.configDir}/${dir}") piPackageDirs)
          }
        '';
      };

    containers.asuka = {
      autoStart = false;
      ephemeral = true;
      privateUsers = "pick";
      privateNetwork = false;
      extraFlags = [
        "--private-users-ownership=map"
        "--bind=${hostHome}/Projects:${hostHome}/Projects:idmap"
        # Keep nspawn from creating root-owned parents in Pi's configuration directory.
        "--bind=${hostPi.sessionsDir}:${guestPi.sessionsDir}:idmap"
        "--bind=${hostPi.authDir}:${guestPi.authDir}:idmap"
      ]
      ++ map (
        dir: "--bind-ro=${hostPi.configDir}/${dir}:${guestPi.packagesDir}/${dir}:idmap"
      ) piPackageDirs
      ++ lib.mapAttrsToList (
        name: secret: "--bind-ro=${secret.path}:${guestPi.secretsDir}/${name}:idmap"
      ) hostPi.secrets;

      specialArgs = { inherit home-manager; };
      config = {
        imports = [ ./sandbox-guest.nix ];

        nixpkgs.pkgs = pkgs;
        system.stateVersion = config.custom.stateVersion;
        custom.mainUser = hostUser;

        users.users = {
          root.initialHashedPassword = config.users.users.${hostUser}.initialHashedPassword;
          ${hostUser} = {
            uid = config.users.users.${hostUser}.uid;
            home = hostHome;
          };
        };

        home-manager.users.${hostUser} = {
          imports = [ ../../../home/development/agents/sandbox-container.nix ];
          custom.development.agentSandbox = {
            authPath = "${guestPi.authDir}/auth.json";
            secretPaths = lib.mapAttrs (name: _: "${guestPi.secretsDir}/${name}") hostPi.secrets;
            container = {
              inherit (guestPi) sessionsDir packagesDir;
            };
          };
        };

        nix.daemon.enable = false;
      };
    };
  };
}
