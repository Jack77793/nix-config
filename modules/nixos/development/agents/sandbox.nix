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
  hostPiConfigDir = config.home-manager.users.${hostUser}.programs.pi-coding-agent.configDir;
  hostPiStateDir = dirOf hostPiConfigDir;
  hostPiSessions = "${hostPiStateDir}/pi-sandboxed-sessions";
  hostPiAuth = "${hostPiStateDir}/pi-sandboxed-auth";
  hostPiSecrets = {
    inherit (config.age.secrets) gemini deepseek;
  };

  guestPiSessions = "/var/lib/pi-sandboxed-sessions";
  guestPiAuth = "/var/lib/pi-sandboxed-auth";
  guestPiPackages = "/var/lib/pi-host-packages";
  guestPiSecrets = "/run/pi-sandboxed-secrets";

  piPackageDirs = [
    "npm"
    "git"
  ];
in
{
  options.custom.development.agentSandbox.enable = lib.mkEnableOption "sandbox for coding agents";

  config = lib.mkIf config.custom.development.agentSandbox.enable {
    systemd.tmpfiles.rules = map (path: "d ${path} 0700 ${hostUser} users - -") [
      hostPiSessions
      hostPiAuth
    ];

    home-manager.users.${hostUser} =
      { lib, ... }:
      {
        home.activation.piSandboxPackageDirs = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
          run mkdir -p -m 0700 -- ${
            lib.escapeShellArgs (map (dir: "${hostPiConfigDir}/${dir}") piPackageDirs)
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
        "--bind=${hostPiSessions}:${guestPiSessions}:idmap"
        "--bind=${hostPiAuth}:${guestPiAuth}:idmap"
      ]
      ++ map (dir: "--bind-ro=${hostPiConfigDir}/${dir}:${guestPiPackages}/${dir}:idmap") piPackageDirs
      ++ lib.mapAttrsToList (
        name: secret: "--bind-ro=${secret.path}:${guestPiSecrets}/${name}:idmap"
      ) hostPiSecrets;

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

        home-manager = {
          extraSpecialArgs = {
            piSandboxSessionsDir = guestPiSessions;
            piSandboxPackagesDir = guestPiPackages;
            piAuthPath = "${guestPiAuth}/auth.json";
            piSecrets = lib.mapAttrs (name: _: "${guestPiSecrets}/${name}") hostPiSecrets;
          };
          users.${hostUser}.imports = [ ../../../home/development/agents/sandbox-container.nix ];
        };

        nix.daemon.enable = false;
      };
    };
  };
}
