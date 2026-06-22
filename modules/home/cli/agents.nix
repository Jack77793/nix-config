{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:

lib.mkIf osConfig.custom.desktop.enable {
  programs = {
    pi-coding-agent = {
      enable = true;
      extraPackages = with pkgs; [
        nodejs
        ffmpeg
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
        defaultModel = "deepseek-v4-pro";
        packages = [
          "npm:pi-mono-context"
          "npm:pi-mono-context-guard"
          "npm:pi-permission-system"
          "npm:pi-web-access"
          "npm:pi-rewind-hook"
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
          silentCheckpoints = true;
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
      "${config.programs.pi-coding-agent.configDir}/pi-permissions.jsonc".text = builtins.toJSON {
        defaultPolicy = {
          tools = "ask";
          bash = "ask";
          mcp = "ask";
          skills = "ask";
          special = "ask";
        };
        tools = {
          read = "allow";
          write = "ask";
          grep = "allow";
          find = "allow";
          ls = "allow";
          ask_user_question = "allow";
        };
        bash = {
          "git *" = "ask";
          "git diff *" = "allow";
          "git log *" = "allow";
          "git status *" = "allow";
          "rm -rf *" = "deny";
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
    };
  };
}
