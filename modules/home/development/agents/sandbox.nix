{
  config,
  lib,
  pkgs,
  piSandboxSessionsDir,
  piSandboxAuthDir,
  piSandboxPackagesDir,
  piSandboxSecretsDir,
  ...
}:

let
  piSettings = "${config.programs.pi-coding-agent.configDir}/settings.json";
  piAuth = "${piSandboxAuthDir}/auth.json";
  piAuthSeed = (pkgs.formats.json { }).generate "pi-sandbox-auth.json" {
    google = {
      type = "api_key";
      key = "!cat ${piSandboxSecretsDir}/gemini";
    };
    deepseek = {
      type = "api_key";
      key = "!cat ${piSandboxSecretsDir}/deepseek";
    };
  };
in
{
  imports = [
    ./codex.nix
    ./pi.nix
    ./chrome-devtools.nix
    ../git.nix
    ../uv.nix
    ../neovim
    ../../security/gpg.nix
    ../../terminal/packages.nix
    ../../terminal/tools.nix
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

    file = {
      "${piSettings}".enable = false;
      "${config.programs.pi-coding-agent.configDir}/sessions".source =
        config.lib.file.mkOutOfStoreSymlink piSandboxSessionsDir;
      "${config.programs.pi-coding-agent.configDir}/auth.json".source =
        config.lib.file.mkOutOfStoreSymlink piAuth;
      "${config.programs.pi-coding-agent.configDir}/npm".source =
        config.lib.file.mkOutOfStoreSymlink "${piSandboxPackagesDir}/npm";
      "${config.programs.pi-coding-agent.configDir}/git".source =
        config.lib.file.mkOutOfStoreSymlink "${piSandboxPackagesDir}/git";
    };
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
        path = piAuth;
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
