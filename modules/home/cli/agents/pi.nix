{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:

let
  piConfigDir = config.programs.pi-coding-agent.configDir;
  authPath = "${piConfigDir}/auth.json";
  authSeed = pkgs.writeText "pi-auth-seed.json" (
    builtins.toJSON {
      google = {
        type = "api_key";
        key = "!cat ${osConfig.age.secrets.gemini.path}";
      };
      deepseek = {
        type = "api_key";
        key = "!cat ${osConfig.age.secrets.deepseek.path}";
      };
    }
  );
in
lib.mkIf osConfig.custom.desktop.enable {
  programs = {
    pi-coding-agent = {
      enable = true;
      context = ./AGENTS.md;
      extraPackages = with pkgs; [
        ffmpeg
        mcp-nixos
        nodejs
        yt-dlp
      ];
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
        skills = [
          "${pkgs.humanizer}/humanizer"
          "${pkgs.humanizer-zh}/humanizer-zh"
          "${pkgs.anthropics-skills}/doc-coauthoring"
          "${pkgs.anthropics-skills}/docx"
          "${pkgs.anthropics-skills}/pdf"
          "${pkgs.anthropics-skills}/pptx"
          "${pkgs.anthropics-skills}/xlsx"
        ];
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
    mcp = {
      enable = true;
      servers = {
        chrome-devtools = {
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
        nixos = {
          command = "mcp-nixos";
        };
      };
    };
  };

  home = {
    activation = {
      pi-auth = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        if [[ ! -e ${lib.escapeShellArg authPath} && ! -L ${lib.escapeShellArg authPath} ]]; then
          run install -D -m 0600 ${authSeed} ${lib.escapeShellArg authPath}
        fi
      '';
      pi-mcp-sync = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        rm -f ${piConfigDir}/mcp.json
      '';
    };
  };
}
