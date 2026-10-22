{
  config,
  lib,
  pkgs,
  home-manager,
  myVars,
  ...
}:

let
  hostUser = config.custom.mainUser;
  hostHome = config.users.users.${hostUser}.home;
  hostHM = config.home-manager.users.${hostUser};
  hostPkgs = pkgs;
  stateVersion = config.custom.stateVersion;
  guestName = "asuka";
  guestHome = hostHome;
  guestPiDir = "${guestHome}/.pi/agent";
  stateDirectory = "${hostHM.xdg.dataHome}/agent-sandbox/${guestName}";
  persistentHome = "${stateDirectory}/home";
  piSessions = "${dirOf hostHM.programs.pi-coding-agent.configDir}/pi-sandboxed-sessions";
in
{
  options.custom.development.agentSandbox.enable = lib.mkEnableOption "sandbox for coding agents";

  config = lib.mkIf config.custom.development.agentSandbox.enable {
    systemd.tmpfiles.rules = map (path: "d ${path} 0700 ${hostUser} users - -") [
      stateDirectory
      persistentHome
      "${persistentHome}/Projects"
      "${persistentHome}/.pi"
      "${persistentHome}/.pi/agent"
      "${persistentHome}/.pi/agent/sessions"
      "${persistentHome}/.gnupg"
      piSessions
    ];

    containers.${guestName} = {
      autoStart = false;
      ephemeral = true;
      privateUsers = "pick";
      privateNetwork = false;
      extraFlags = [
        "--private-users-ownership=map"
        "--bind=${persistentHome}:${guestHome}:idmap"
        "--bind=${hostHome}/Projects:${hostHome}/Projects:idmap"
        "--bind=${piSessions}:${guestPiDir}/sessions:idmap"
      ];

      config = {
        imports = [ home-manager.nixosModules.home-manager ];

        nixpkgs.pkgs = hostPkgs;

        system.stateVersion = stateVersion;

        users.mutableUsers = false;
        users.users.root.initialHashedPassword = config.users.users.${hostUser}.initialHashedPassword;
        users.users.${guestName} = {
          isNormalUser = true;
          uid = config.users.users.${hostUser}.uid;
          group = "users";
          home = guestHome;
          shell = pkgs.zsh;
          linger = true;
          hashedPassword = "!";
        };

        programs.zsh.enable = true;
        services.dbus.enable = true;

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          enableLegacyProfileManagement = false;
          extraSpecialArgs = { inherit myVars; };

          users.${guestName} =
            {
              config,
              lib,
              pkgs,
              ...
            }:
            let
              chromeDevtools = {
                command = "npx";
                args = [
                  "-y"
                  "chrome-devtools-mcp@latest"
                  "--no-usage-statistics"
                  "--executable-path=${pkgs.chromium}/bin/chromium"
                  "--headless"
                  "--isolated"
                  "--chromeArg=--no-first-run"
                  "--chromeArg=--no-default-browser-check"
                  "--chromeArg=--disable-search-engine-choice-screen"
                  "--chrome-arg=--disable-blink-features=AutomationControlled"
                ];
              };
            in
            {
              imports = [
                ../../../home/development/agents/codex.nix
                ../../../home/development/agents/pi.nix
                ../../../home/development/git.nix
                ../../../home/development/uv.nix
                ../../../home/development/neovim
                ../../../home/security/gpg.nix
                ../../../home/terminal/packages.nix
                ../../../home/terminal/tools.nix
                ../../../home/terminal/shell
              ];

              home = {
                username = guestName;
                homeDirectory = guestHome;
                inherit stateVersion;
                packages =
                  (with pkgs; [
                    curl
                    wget
                    openssh
                    nodejs
                    pnpm
                    gcc
                    cmake
                    pkg-config
                  ])
                  ++ config.programs.pi-coding-agent.extraPackages;
                sessionVariables = {
                  TERM = "xterm-256color";
                  JITI_FS_CACHE = "${config.xdg.cacheHome}/jiti";
                  npm_config_cache = "${config.xdg.cacheHome}/npm";
                  PNPM_HOME = "${config.xdg.dataHome}/pnpm";
                };
                sessionPath = [ "${config.xdg.dataHome}/pnpm" ];

                file."${guestPiDir}/settings.json".enable = false;
                activation.piMutableSettings = lib.hm.dag.entryAfter [ "linkGeneration" ] (
                  lib.hm.generators.mkImpureConfigMerger {
                    inherit pkgs;
                    format = "json";
                    empty = "{}";
                    jqOperation = "$dynamic * $static";
                    path = "${guestPiDir}/settings.json";
                    staticSettings =
                      (pkgs.formats.json { }).generate "pi-sandbox-settings.json"
                        config.programs.pi-coding-agent.settings;
                    mode = "600";
                  }
                );
              };

              custom.development.neovim.extended = true;

              programs = {
                home-manager.enable = true;
                mcp.servers.chrome-devtools = chromeDevtools;
                codex.settings.mcp_servers.chrome-devtools = chromeDevtools;
                git = {
                  signing.key = lib.mkForce null;
                  includes = [ { path = "${config.xdg.configHome}/git/sandbox-signing.conf"; } ];
                };
              };
            };
        };

        nix = {
          daemon.enable = false;
          settings.experimental-features = config.nix.settings.experimental-features;
          nixPath = [ "nixpkgs=${hostPkgs.path}" ];
        };
      };
    };
  };
}
