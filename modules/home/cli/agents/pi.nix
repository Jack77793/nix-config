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
        theme = "dark";
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
        terminal.showImages = true;
        defaultProvider = "deepseek";
        defaultModel = "deepseek-flash";
        packages = [
          "npm:pi-codex-goal"
          "npm:pi-mcp-adapter"
          "npm:pi-mono-context"
          "npm:pi-rewind-hook"
          "npm:pi-web-access"
          "npm:@gotgenes/pi-permission-system"
          "npm:@gotgenes/pi-subagents"
          "npm:@juicesharp/rpiv-ask-user-question"
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

  home = {
    file = {
      "${piConfigDir}/extensions/pi-permission-system/config.json".text = builtins.toJSON {
        permission = {
          "*" = "allow";
          path = {
            "*.env" = "deny";
            "*.env.*" = "deny";
            "~/.ssh" = "deny";
            "~/.ssh/*" = "deny";
            "~/.gnupg" = "deny";
            "~/.gnupg/*" = "deny";
          };
          bash = {
            "*" = "allow";
            "rm -rf *" = "deny";
            "sudo *" = "deny";
          };
        };
      };
      "${config.xdg.configHome}/mcp/mcp.json".text = builtins.toJSON {
        mcpServers = {
          chrome-devtools = {
            command = "npx";
            args = [
              "-y"
              "chrome-devtools-mcp@latest"
              "--no-usage-statistics"
              "--executable-path=${pkgs.chromium}/bin/chromium"
              "--headless"
              "--isolated"
            ];
          };
          nixos = {
            command = "mcp-nixos";
            lifecycle = "lazy";
          };
        };
      };
    };
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
