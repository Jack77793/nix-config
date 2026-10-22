{ pkgs, ... }:

{
  imports = [ ./mcp.nix ];

  programs = {
    pi-coding-agent = {
      enable = true;
      context = ./AGENTS.md;
      extraPackages = with pkgs; [
        ffmpeg
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
