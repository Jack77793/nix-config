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
    imports = [ ../../../home/modules/development/agents/pi.nix ];

    programs.mcp.servers.chrome-devtools = {
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

    home.activation = {
      pi-auth = hm.dag.entryAfter [ "linkGeneration" ] ''
        if [[ ! -e ${lib.escapeShellArg authPath} && ! -L ${lib.escapeShellArg authPath} ]]; then
          run install -D -m 0600 ${authSeed} ${lib.escapeShellArg authPath}
        fi
      '';
      pi-mcp-sync = hm.dag.entryAfter [ "writeBoundary" ] ''
        rm -f ${piConfigDir}/mcp.json
      '';
    };
  };
}
