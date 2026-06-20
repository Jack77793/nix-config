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
          "${pkgs.humanizer}/share/humanizer"
          "${pkgs.humanizer-zh}/share/humanizer-zh"
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
      models = {
        providers = {
          deepseek = {
            api = "openai-completions";
            apiKey = "!cat ${osConfig.age.secrets.opencode-ds.path}";
            baseUrl = "https://api.deepseek.com";
            models = [
              {
                id = "deepseek-v4-pro";
                name = "DeepSeek V4 Pro";
                reasoning = true;
                contextWindow = 1000000;
                maxTokens = 384000;
                input = [ "text" ];
                cost = {
                  input = 1.74;
                  output = 3.48;
                  cacheRead = 0.145;
                  cacheWrite = 0;
                };
                thinkingLevelMap = {
                  minimal = null;
                  low = null;
                  medium = null;
                  high = "high";
                  xhigh = "max";
                };
                compat = {
                  requiresReasoningContentOnAssistantMessages = true;
                  thinkingFormat = "deepseek";
                };
              }
              {
                id = "deepseek-v4-flash";
                name = "DeepSeek V4 Flash";
                reasoning = true;
                contextWindow = 1000000;
                maxTokens = 384000;
                input = [ "text" ];
                cost = {
                  input = 0.14;
                  output = 0.28;
                  cacheRead = 0.028;
                  cacheWrite = 0;
                };
                thinkingLevelMap = {
                  minimal = null;
                  low = null;
                  medium = null;
                  high = "high";
                  xhigh = "max";
                };
                compat = {
                  requiresReasoningContentOnAssistantMessages = true;
                  thinkingFormat = "deepseek";
                };
              }
            ];
          };
        };
      };
    };

    opencode = {
      enable = true;
      package = (
        pkgs.symlinkJoin {
          name = "opencode.wrapped";
          paths = [ pkgs.opencode ];
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/opencode \
            --set OPENCODE_DISABLE_LSP_DOWNLOAD "true" \
            --set TMPDIR "/var/tmp"
          '';
        }
      );
      extraPackages = with pkgs; [
        bash-language-server
        clang-tools
        lua-language-server
        nixd
        pyright
        rust-analyzer
      ];
      settings = {
        autoupdate = false;
        formatter = true;
        lsp = true;
        provider = {
          deepseek.options.apiKey = "{file:${osConfig.age.secrets.opencode-ds.path}}";
          google.options.apiKey = "{file:${osConfig.age.secrets.gemini.path}}";
        };
        permission = {
          "*" = "ask";
          read = "allow";
          grep = "allow";
          glob = "allow";
          lsp = "allow";
          todowrite = "allow";
          webfetch = "allow";
          websearch = "allow";
          question = "allow";
          bash = {
            "ls *" = "allow";
            "git diff *" = "allow";
            "git log *" = "allow";
            "git status *" = "allow";
          };
        };
        share = "disabled";
      };
      tui.theme = "nord";
      skills = {
        humanizer = "${pkgs.humanizer}/share/humanizer/SKILL.md";
        humanizer-zh = "${pkgs.humanizer-zh}/share/humanizer-zh/SKILL.md";
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
