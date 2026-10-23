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
  hostHM = config.home-manager.users.${hostUser};
  guestName = "asuka";
  guestHome = hostHome;
  guestPiSessions = "/var/lib/pi-sandboxed-sessions";
  guestPiAuth = "/var/lib/pi-sandboxed-auth";
  guestPiPackages = "/var/lib/pi-host-packages";
  guestPiSecrets = "/run/pi-sandboxed-secrets";
  piSecrets = {
    inherit (config.age.secrets) gemini deepseek;
  };
  piPackageDirs = [
    "npm"
    "git"
  ];
  piConfigDir = hostHM.programs.pi-coding-agent.configDir;
  piStateDir = dirOf piConfigDir;
  piSessions = "${piStateDir}/pi-sandboxed-sessions";
  piAuth = "${piStateDir}/pi-sandboxed-auth";
in
{
  options.custom.development.agentSandbox.enable = lib.mkEnableOption "sandbox for coding agents";

  config = lib.mkIf config.custom.development.agentSandbox.enable {
    systemd.tmpfiles.rules = map (path: "d ${path} 0700 ${hostUser} users - -") [
      piSessions
      piAuth
    ];

    home-manager.users.${hostUser} =
      { lib, ... }:
      {
        home.activation.piSandboxPackageDirs = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
          run mkdir -p -m 0700 -- ${lib.escapeShellArgs (map (dir: "${piConfigDir}/${dir}") piPackageDirs)}
        '';
      };

    containers.${guestName} = {
      autoStart = false;
      ephemeral = true;
      privateUsers = "pick";
      privateNetwork = false;
      extraFlags = [
        "--private-users-ownership=map"
        "--bind=${hostHome}/Projects:${hostHome}/Projects:idmap"
        # Keep nspawn from creating root-owned parents in Pi's configuration directory.
        "--bind=${piSessions}:${guestPiSessions}:idmap"
        "--bind=${piAuth}:${guestPiAuth}:idmap"
      ]
      ++ map (dir: "--bind-ro=${piConfigDir}/${dir}:${guestPiPackages}/${dir}:idmap") piPackageDirs
      ++ lib.mapAttrsToList (
        name: secret: "--bind-ro=${secret.path}:${guestPiSecrets}/${name}:idmap"
      ) piSecrets;

      specialArgs = { inherit home-manager; };
      config = {
        imports = [ ./sandbox-guest.nix ];

        nixpkgs.pkgs = pkgs;
        system.stateVersion = config.custom.stateVersion;
        custom.mainUser = hostUser;

        users.users.root.initialHashedPassword = config.users.users.${hostUser}.initialHashedPassword;
        users.users.${hostUser} = {
          uid = config.users.users.${hostUser}.uid;
          home = guestHome;
        };

        home-manager.extraSpecialArgs = {
          piSandboxSessionsDir = guestPiSessions;
          piSandboxAuthDir = guestPiAuth;
          piSandboxPackagesDir = guestPiPackages;
          piSandboxSecretsDir = guestPiSecrets;
        };

        nix.daemon.enable = false;
      };
    };
  };
}
