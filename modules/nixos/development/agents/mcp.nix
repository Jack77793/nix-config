{
  config,
  lib,
  pkgs,
  ...
}:

let
  commonArgs = [
    "-y"
    "chrome-devtools-mcp@latest"
    "--no-usage-statistics"
    "--executable-path=${pkgs.chromium}/bin/chromium"
  ];
  chromeArgs = [
    "--chromeArg=--no-first-run"
    "--chromeArg=--no-default-browser-check"
    "--chromeArg=--disable-search-engine-choice-screen"
    "--chrome-arg=--disable-blink-features=AutomationControlled"
  ];
in
lib.mkIf config.custom.desktop.enable {
  home-manager.users.${config.custom.mainUser} =
    { config, lib, ... }:
    lib.mkIf config.programs.mcp.enable {
      programs.codex.settings.mcp_servers = lib.mkIf config.programs.codex.enable {
        chrome-devtools = {
          command = "npx";
          args =
            commonArgs
            ++ [
              "--isolated"
              "--chromeArg=--ozone-platform=wayland"
            ]
            ++ chromeArgs;
          env_vars = [
            "WAYLAND_DISPLAY"
            "XDG_RUNTIME_DIR"
            "DBUS_SESSION_BUS_ADDRESS"
          ];
        };
      };

      programs.mcp.servers.chrome-devtools = {
        command = "npx";
        args =
          commonArgs
          ++ [
            "--headless"
            "--isolated"
          ]
          ++ chromeArgs;
      };

      home.activation = lib.mkIf config.programs.pi-coding-agent.enable {
        pi-mcp-sync = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          rm -f ${config.programs.pi-coding-agent.configDir}/mcp.json
        '';
      };
    };
}
