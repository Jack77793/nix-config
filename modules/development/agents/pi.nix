{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.file."${config.programs.pi-coding-agent.configDir}/mcp.json".text = builtins.toJSON {
    mcpServers = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
      nixos.command = "mcp-nixos";
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
    };
  };

  programs = {
    pi-coding-agent = {
      enable = true;
      context = ./AGENTS.md;
      extraPackages =
        (with pkgs; [
          ffmpeg
          nodejs
          yt-dlp
        ])
        ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.mcp-nixos ];
      settings = {
        theme = "system";
        enableInstallTelemetry = false;
        enableAnalytics = false;
        compaction = {
          enabled = true;
          reserveTokens = 16384;
          keepRecentTokens = 20000;
        };
        retry = {
          enabled = true;
          maxRetries = 3;
        };
        terminal.showImages = false;
        tuiMode = "regular";
        defaultProvider = "deepseek";
        defaultModel = "deepseek-flash";
        packages = [
          "npm:pi-mcp-adapter"
          "npm:pi-rewind-hook"
          "npm:pi-web-access"
          "npm:@juicesharp/rpiv-ask-user-question"
          "npm:@narumitw/pi-usage"
        ];
        skills = builtins.attrValues (import ./skills.nix { inherit pkgs; });
        extensions = [
          "-builtin:mcp"
        ];
        rewind = {
          silentCheckpoints = false;
          retention = {
            maxSnapshots = 256;
            maxAgeDays = 7;
            pinLabeledEntries = false;
          };
        };
      };
    };
  };
}
