{
  config,
  pkgs,
  osConfig,
  ...
}:

let
  secrets = if pkgs.stdenv.hostPlatform.isDarwin then config.age.secrets else osConfig.age.secrets;
in
{
  home.file."${config.programs.pi-coding-agent.configDir}/mcp.json" = {
    enable = config.programs.mcp.enable;
    source = config.xdg.configFile."mcp/mcp.json".source;
  };

  programs = {
    pi-coding-agent = {
      enable = true;
      context = ./AGENTS.md;
      extraPackages = with pkgs; [
        ffmpeg
        nodejs
        yt-dlp
      ];
      models.providers = {
        google.apiKey = "!cat ${secrets.gemini.path}";
        deepseek.apiKey = "!cat ${secrets.deepseek.path}";
      };
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
        defaultTools = [
          "+read"
          "+bash"
          "+edit"
          "+write"
          "+ls"
          "+codemode"
        ];
        packages = [
          "npm:pi-mcp-adapter"
          "npm:pi-web-access"
          "npm:@juicesharp/rpiv-ask-user-question"
          "npm:@monotykamary/pi-tps"
          "npm:@narumitw/pi-usage"
        ];
        skills = builtins.attrValues (import ./skills.nix { inherit pkgs; });
        extensions = [
          "-builtin:mcp"
        ];
      };
    };
  };
}
