{ pkgs, ... }:

{
  programs.mcp = {
    enable = true;
    servers = {
      chrome-devtools = {
        command = "${pkgs.nodejs}/bin/npx";
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
      nixos.command = "${pkgs.mcp-nixos}/bin/mcp-nixos";
    };
  };
}
