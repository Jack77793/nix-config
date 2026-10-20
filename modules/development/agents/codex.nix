{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.custom.desktop.enable {
  home-manager.users.${config.custom.mainUser}.imports = [
    ../../../home/modules/development/agents/codex.nix
    {
      home.packages = [ pkgs.bubblewrap ];

      programs.codex.settings.mcp_servers.chrome-devtools = {
        command = "npx";
        args = [
          "-y"
          "chrome-devtools-mcp@latest"
          "--no-usage-statistics"
          "--executable-path=${pkgs.chromium}/bin/chromium"
          "--isolated"
          "--chromeArg=--ozone-platform=wayland"
          "--chromeArg=--no-first-run"
          "--chromeArg=--no-default-browser-check"
          "--chromeArg=--disable-search-engine-choice-screen"
          "--chrome-arg=--disable-blink-features=AutomationControlled"
        ];
        env_vars = [
          "WAYLAND_DISPLAY"
          "XDG_RUNTIME_DIR"
          "DBUS_SESSION_BUS_ADDRESS"
        ];
      };
    }
  ];
}
