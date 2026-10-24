{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

let
  piConfigDir = config.programs.pi-coding-agent.configDir;
  piSettings = "${piConfigDir}/settings.json";
  piAuthPath = "${piConfigDir}/auth.json";
  piAuthSeed = (pkgs.formats.json { }).generate "pi-sandbox-auth.json" {
    google = {
      type = "api_key";
      key = "!cat ${osConfig.age.secrets.gemini.path}";
    };
    deepseek = {
      type = "api_key";
      key = "!cat ${osConfig.age.secrets.deepseek.path}";
    };
  };
in
{
  imports = [
    ../../modules/home/development/agents/codex.nix
    ../../modules/home/development/agents/pi.nix
    ../../modules/home/development/agents/chrome-devtools.nix
    ../../modules/home/development/git.nix
    ../../modules/home/development/uv.nix
    ../../modules/home/development/neovim
    ../../modules/home/security/gpg.nix
    ../../modules/home/terminal/packages.nix
    ../../modules/home/terminal/tools.nix
  ];

  custom.development.neovim.extended = true;

  programs.bash.enable = true;

  home = {
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

    file."${piSettings}".enable = false;
    activation.piMutableSettings = lib.hm.dag.entryAfter [ "linkGeneration" ] (
      lib.hm.generators.mkImpureConfigMerger {
        inherit pkgs;
        format = "json";
        empty = "{}";
        jqOperation = "$dynamic * $static";
        path = piSettings;
        staticSettings =
          (pkgs.formats.json { }).generate "pi-sandbox-settings.json"
            config.programs.pi-coding-agent.settings;
        mode = "600";
      }
    );
    activation.piAuth = lib.hm.dag.entryAfter [ "linkGeneration" ] (
      lib.hm.generators.mkImpureConfigMerger {
        inherit pkgs;
        format = "json";
        empty = "{}";
        jqOperation = "$dynamic * $static";
        path = piAuthPath;
        staticSettings = piAuthSeed;
        mode = "600";
      }
    );
  };

  programs.git = {
    signing.key = lib.mkForce null;
    includes = [ { path = "${config.xdg.configHome}/git/sandbox-signing.conf"; } ];
  };
}
