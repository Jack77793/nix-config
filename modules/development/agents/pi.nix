{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:

let
  piConfigDir = config.programs.pi-coding-agent.configDir;
  authPath = "${piConfigDir}/auth.json";
  settingsPath = "${piConfigDir}/settings.json";
  sandbox = (osConfig.custom.profile or null) == "sandbox";
  secrets =
    if pkgs.stdenv.hostPlatform.isDarwin then
      config.age.secrets or { }
    else
      osConfig.age.secrets or { };
  authSeed = pkgs.writeText "pi-auth-seed.json" (
    builtins.toJSON {
      google = {
        type = "api_key";
        key = "!cat ${secrets.gemini.path}";
      };
      deepseek = {
        type = "api_key";
        key = "!cat ${secrets.deepseek.path}";
      };
    }
  );
in
{
  home.file."${piConfigDir}/mcp.json".text = builtins.toJSON {
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

  home.packages = lib.optionals sandbox config.programs.pi-coding-agent.extraPackages;

  home.file."${settingsPath}".enable = lib.mkIf sandbox false;
  home.activation.piMutableSettings = lib.mkIf sandbox (
    lib.hm.dag.entryAfter [ "linkGeneration" ] (
      lib.hm.generators.mkImpureConfigMerger {
        inherit pkgs;
        format = "json";
        empty = "{}";
        jqOperation = "$dynamic * $static";
        path = settingsPath;
        staticSettings =
          (pkgs.formats.json { }).generate "pi-sandbox-settings.json"
            config.programs.pi-coding-agent.settings;
        mode = "600";
      }
    )
  );

  home.activation.piAuth = lib.hm.dag.entryAfter [ "linkGeneration" ] (
    lib.hm.generators.mkImpureConfigMerger {
      inherit pkgs;
      format = "json";
      empty = "{}";
      jqOperation = "$dynamic * $static";
      path = authPath;
      staticSettings = authSeed;
      mode = "600";
    }
  );

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
