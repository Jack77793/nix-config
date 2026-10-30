{
  config,
  lib,
  pkgs,
  _class,
  ...
}:

{
  imports = [
    ./neovim
    ./agents
  ];

  options.custom.development.enable = lib.mkEnableOption "extended development tools";

  config = {
    home-manager.users.${config.custom.mainUser} =
      { config, osConfig, ... }:
      {
        imports = [ ./git.nix ] ++ lib.optional osConfig.custom.development.enable ./uv.nix;
        home =
          lib.mkIf (osConfig.custom.development.enable && (osConfig.custom.profile or null) == "sandbox")
            {
              packages = with pkgs; [
                curl
                wget
                openssh
                nodejs
                pnpm
                gcc
                cmake
                pkg-config
              ];
              sessionVariables = {
                TERM = "xterm-256color";
                JITI_FS_CACHE = "${config.xdg.cacheHome}/jiti";
                npm_config_cache = "${config.xdg.cacheHome}/npm";
                PNPM_HOME = "${config.xdg.dataHome}/pnpm";
              };
              sessionPath = [ "${config.xdg.dataHome}/pnpm" ];
            };
      }
      // lib.optionalAttrs (_class == "nixos") {
        custom.development.python.extraPackages = lib.mkAfter (
          ps:
          lib.optionals (osConfig.custom.development.enable && osConfig.custom.desktop.enable) [
            ps.secretstorage
          ]
        );
      };
  }
  // lib.optionalAttrs (_class == "nixos") {
    environment.systemPackages = [ pkgs.git ];
  };
}
