{ pkgs, ... }:

let
  chromeDevtools = {
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
in
{
  programs.mcp.servers.chrome-devtools = chromeDevtools;
  programs.codex.settings.mcp_servers.chrome-devtools = chromeDevtools;
}
