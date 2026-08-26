{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:

lib.mkIf osConfig.custom.desktop.enable {
  home.packages = with pkgs; [ dsh ];

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
        defaultModel = "deepseek-v4-flash";
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
      "${config.programs.pi-coding-agent.configDir}/auth.json".text = builtins.toJSON {
        google = {
          type = "api_key";
          key = "!cat ${osConfig.age.secrets.gemini.path}";
        };
        deepseek = {
          type = "api_key";
          key = "!cat ${osConfig.age.secrets.deepseek.path}";
        };
      };
      "${config.programs.pi-coding-agent.configDir}/extensions/pi-permission-system/config.json".text =
        builtins.toJSON
          {
            permission = {
              "*" = "ask";
              path = {
                "*" = "allow";
                "*.env" = "deny";
                "*.env.*" = "deny";
                "~/.ssh" = "deny";
                "~/.ssh/*" = "deny";
                "~/.gnupg" = "deny";
                "~/.gnupg/*" = "deny";
              };
              read = "allow";
              write = "ask";
              grep = "allow";
              find = "allow";
              ls = "allow";
              bash = {
                "*" = "ask";
                "git diff *" = "allow";
                "git log *" = "allow";
                "git show *" = "allow";
                "git status *" = "allow";
                "gh issue list *" = "allow";
                "gh issue view *" = "allow";
                "gh pr diff *" = "allow";
                "gh pr list *" = "allow";
                "gh pr view *" = "allow";
                "gh repo list *" = "allow";
                "gh repo view *" = "allow";
                "nix build *" = "allow";
                "nix eval *" = "allow";
                "nix flake check *" = "allow";
                "nix flake metadata *" = "allow";
                "nix flake show *" = "allow";
                "nix search *" = "allow";
                "nix store ls *" = "allow";
                "nix store verify *" = "allow";
                "rm -rf *" = "deny";
                "sudo *" = "deny";
              };
              mcp = "ask";
              skills = "ask";
              external_directory = "ask";
              ask_user_question = "allow";
              web_search = "allow";
              fetch_content = "allow";
              create_goal = "allow";
              get_goal = "allow";
              update_goal = "allow";
              subagent = "allow";
              get_subagent_result = "allow";
              steer_subagent = "allow";
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
              "--isolated"
            ];
          };
          nixos = {
            command = "mcp-nixos";
            lifecycle = "lazy";
          };
        };
      };
      "${config.programs.pi-coding-agent.configDir}/../web-search.json.template".text = builtins.toJSON {
        provider = "gemini";
        geminiApiKey = "@geminiApiKey@";
        summaryModel = "deepseek/deepseek-v4-flash";
      };
    };
    activation = {
      pi-web-access = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        sed "s|@geminiApiKey@|$(cat ${osConfig.age.secrets.gemini.path})|g" ${config.programs.pi-coding-agent.configDir}/../web-search.json.template > ${config.programs.pi-coding-agent.configDir}/../web-search.json
        chmod 600 ${config.programs.pi-coding-agent.configDir}/../web-search.json
      '';
      pi-mcp-sync = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        rm -f ${config.programs.pi-coding-agent.configDir}/mcp.json
      '';
    };
  };
}
