{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.custom.development.agentSandbox;
  piSettings = "${config.programs.pi-coding-agent.configDir}/settings.json";
  piAuthSeed = (pkgs.formats.json { }).generate "pi-sandbox-auth.json" {
    google = {
      type = "api_key";
      key = "!cat ${cfg.secretPaths.gemini}";
    };
    deepseek = {
      type = "api_key";
      key = "!cat ${cfg.secretPaths.deepseek}";
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

  options.custom.development.agentSandbox = {
    authPath = lib.mkOption {
      type = lib.types.nonEmptyStr;
      default = "${config.programs.pi-coding-agent.configDir}/auth.json";
      defaultText = lib.literalExpression ''"''${config.programs.pi-coding-agent.configDir}/auth.json"'';
      description = "Runtime path to the writable Pi authentication file";
    };

    secretPaths = lib.genAttrs [ "gemini" "deepseek" ] (
      name:
      lib.mkOption {
        type = lib.types.nonEmptyStr;
        description = "Runtime path to the ${name} API key file";
      }
    );
  };

  config = {
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
          path = cfg.authPath;
          staticSettings = piAuthSeed;
          mode = "600";
        }
      );
    };

    programs.git = {
      signing.key = lib.mkForce null;
      includes = [ { path = "${config.xdg.configHome}/git/sandbox-signing.conf"; } ];
    };
  };
}
