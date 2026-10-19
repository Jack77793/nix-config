{
  config,
  lib,
  pkgs,
  ...
}:

let
  hostUser = config.custom.mainUser;
  hostHome = config.users.users.${hostUser}.home;
  hostHM = config.home-manager.users.${hostUser};
  hostPi = hostHM.programs.pi-coding-agent;
  hostPiRoot = dirOf hostPi.configDir;
  hostGitConfig = "${hostHM.xdg.configHome}/git/config";
  hostPkgs = pkgs;
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
      "--bind=${hostPi.configDir}/auth.json:${guestPiDir}/auth.json:idmap"
      "--bind=${hostHome}/.codex:${hostHome}/.codex:idmap"
      "--bind-ro=${hostPi.configDir}/settings.json:${guestPiDir}/settings.json"
      "--bind-ro=${hostPi.configDir}/AGENTS.md:${guestPiDir}/AGENTS.md"
      "--bind-ro=${hostGitConfig}:${guestHome}/.config/git/config"
      "--bind-ro=${hostHM.xdg.configHome}/mcp/mcp.json:${guestHome}/.config/mcp/mcp.json"
      "--bind-ro=${hostPi.configDir}/npm:${guestPiDir}/npm:idmap"
      "--bind-ro=${config.age.secrets."gemini-sandbox".path}:${config.age.secrets.gemini.path}:idmap"
      "--bind-ro=${config.age.secrets."deepseek-sandbox".path}:${config.age.secrets.deepseek.path}:idmap"
    ];

    config = {
      nixpkgs.pkgs = hostPkgs;

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
        "${guestHome}/.config"
        "${guestHome}/.config/git"
        "${guestHome}/.config/mcp"
      ];

      programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
      };

      environment.systemPackages =
        with hostPkgs;
        [
          codex
          delta
          eza
          fzf
          gh
          git
          git-lfs
          gnumake
          jq
          pi-coding-agent
          pnpm
          python3
          ripgrep
          unzipNLS
          uv
          zip
        ]
        ++ hostPi.extraPackages;

      environment.etc."uv/uv.toml".source =
        (hostPkgs.formats.toml { }).generate "uv.toml"
          hostHM.programs.uv.settings;

      environment.variables = {
        TERM = "xterm-256color";
        UV_CONFIG_FILE = "/etc/uv/uv.toml";
        JITI_FS_CACHE = "${guestHome}/.cache/jiti";
        npm_config_cache = "${guestHome}/.cache/npm";
      };

      nix = {
        daemon.enable = false;
        settings.experimental-features = config.nix.settings.experimental-features;
        nixPath = [ "nixpkgs=${hostPkgs.path}" ];
      };
    };
  };
}
