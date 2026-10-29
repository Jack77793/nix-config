{
  config,
  lib,
  pkgs,
  ...
}:

let
  piConfigDir = config.programs.pi-coding-agent.configDir;
  piSettings = "${piConfigDir}/settings.json";
in
{
  imports = [
    ../../modules/development/agents/home.nix
    ../../modules/development/git.nix
    ../../modules/development/uv.nix
    ../../modules/development/neovim/home.nix
    ../../modules/security/gpg.nix
    ../../modules/terminal/packages.nix
    ../../modules/terminal/tools.nix
  ];

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
  };

  programs.git = {
    signing.key = lib.mkForce null;
    includes = [ { path = "${config.xdg.configHome}/git/sandbox-signing.conf"; } ];
  };
}
