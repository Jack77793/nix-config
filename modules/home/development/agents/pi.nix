{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs = {
    pi-coding-agent = {
      enable = true;
      context = ./AGENTS.md;
      extraPackages =
        with pkgs;
        [ ffmpeg ]
        ++ lib.optionals config.programs.mcp.enable [ mcp-nixos ]
        ++ [
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
        packages = lib.optionals config.programs.mcp.enable [ "npm:pi-mcp-adapter" ] ++ [
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
      servers.nixos.command = "mcp-nixos";
    };
  };
}
