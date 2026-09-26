{
  config,
  lib,
  ...
}:

let
  hostUser = config.custom.mainUser;
  hostHome = config.users.users.${hostUser}.home;
  hostPi = config.home-manager.users.${hostUser}.programs.pi-coding-agent;
  hostPiRoot = dirOf hostPi.configDir;
  guestName = "asuka";
  guestHome = hostHome;
  guestPiDir = "${guestHome}/.pi/agent";
in
lib.mkIf config.custom.extras.agentSandbox.enable {
  boot.specialFileSystems."/run/agent-sandbox-secrets" = {
    fsType = "tmpfs";
    options = [
      "noswap"
      "nosuid"
      "nodev"
      "noexec"
      "mode=0700"
      "size=1M"
    ];
  };

  containers.${guestName} = {
    autoStart = false;
    ephemeral = true;
    privateUsers = "pick";
    privateNetwork = false;
    extraFlags = [
      "--private-users-ownership=map"
      "--bind=${hostHome}/Projects:${hostHome}/Projects:idmap"
      "--bind=${hostPiRoot}/pi-sandboxed-sessions:${guestPiDir}/sessions:idmap"
      "--bind-ro=${hostPi.configDir}/settings.json:${guestPiDir}/settings.json"
      "--bind-ro=${hostPi.configDir}/AGENTS.md:${guestPiDir}/AGENTS.md"
      "--bind-ro=${hostPi.configDir}/auth.json:${guestPiDir}/auth.json"
      "--bind-ro=${hostPi.configDir}/extensions/pi-permission-system/config.json:${guestPiDir}/extensions/pi-permission-system/config.json"
      "--bind-ro=${
        config.home-manager.users.${hostUser}.xdg.configHome
      }/mcp/mcp.json:${guestHome}/.config/mcp/mcp.json"
      "--bind-ro=${hostPiRoot}/web-search.json:${guestHome}/.pi/web-search.json:idmap"
      "--bind-ro=${hostPi.configDir}/npm:${guestPiDir}/npm:idmap"
      "--bind-ro=${config.age.secrets."gemini-sandbox".path}:${config.age.secrets.gemini.path}:idmap"
      "--bind-ro=${config.age.secrets."deepseek-sandbox".path}:${config.age.secrets.deepseek.path}:idmap"
    ];

    config =
      { pkgs, ... }:
      {
        system.stateVersion = config.custom.stateVersion;

        users.mutableUsers = false;
        users.users.root.initialHashedPassword = config.users.users.${hostUser}.initialHashedPassword;
        users.users.${guestName} = {
          isNormalUser = true;
          uid = config.users.users.${hostUser}.uid;
          group = "users";
          home = guestHome;
          hashedPassword = "!";
        };

        systemd.tmpfiles.rules = map (path: "d ${path} 0700 ${guestName} users - -") [
          "${guestHome}/.pi"
          "${guestPiDir}"
          "${guestPiDir}/extensions"
          "${guestPiDir}/extensions/pi-permission-system"
          "${guestHome}/.config"
          "${guestHome}/.config/mcp"
        ];

        environment.systemPackages = [
          pkgs.pi-coding-agent
        ]
        ++ hostPi.extraPackages;
        environment.variables = {
          TERM = "xterm-256color";
          JITI_FS_CACHE = "${guestHome}/.cache/jiti";
          npm_config_cache = "${guestHome}/.cache/npm";
        };

        nix = {
          daemon.enable = false;
          settings.experimental-features = config.nix.settings.experimental-features;
        };
      };
  };
}
