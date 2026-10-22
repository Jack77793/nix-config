{
  config,
  lib,
  pkgs,
  home-manager,
  ...
}:

let
  homeConfig = config.home-manager.users.${config.custom.mainUser};
  inherit (home-manager.lib) hm;
  piConfigDir = homeConfig.programs.pi-coding-agent.configDir;
  authPath = "${piConfigDir}/auth.json";
  authSeed = pkgs.writeText "pi-auth-seed.json" (
    builtins.toJSON {
      google = {
        type = "api_key";
        key = "!cat ${config.age.secrets.gemini.path}";
      };
      deepseek = {
        type = "api_key";
        key = "!cat ${config.age.secrets.deepseek.path}";
      };
    }
  );
in
lib.mkIf config.custom.desktop.enable {
  home-manager.users.${config.custom.mainUser} = {
    home.activation = {
      pi-auth = hm.dag.entryAfter [ "linkGeneration" ] ''
        if [[ ! -e ${lib.escapeShellArg authPath} && ! -L ${lib.escapeShellArg authPath} ]]; then
          run install -D -m 0600 ${authSeed} ${lib.escapeShellArg authPath}
        fi
      '';
    };
  };
}
