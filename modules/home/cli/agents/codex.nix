{
  osConfig,
  lib,
  pkgs,
  ...
}:

lib.mkIf osConfig.custom.desktop.enable {
  home.packages = with pkgs; [
    bubblewrap
    mcp-nixos
    nodejs
  ];

  programs.codex = {
    enable = true;
    mutableSettings = true;
    context = ./AGENTS.md;
    skills = {
      humanizer = "${pkgs.humanizer}/humanizer";
      humanizer-zh = "${pkgs.humanizer-zh}/humanizer-zh";
      doc-coauthoring = "${pkgs.anthropics-skills}/doc-coauthoring";
      docx = "${pkgs.anthropics-skills}/docx";
      pdf = "${pkgs.anthropics-skills}/pdf";
      pptx = "${pkgs.anthropics-skills}/pptx";
      xlsx = "${pkgs.anthropics-skills}/xlsx";
    };
    settings = {
      tui = {
        fullscreen_transcript = false;
        status_line = [
          "model-with-reasoning"
          "current-dir"
          "branch-changes"
          "permissions"
          "approval-mode"
          "context-remaining"
          "five-hour-limit"
          "weekly-limit"
          "run-state"
          "codex-version"
        ];
        status_line_use_colors = true;
        theme = "nord";
      };
      mcp_servers = {
        chrome-devtools = {
          command = "npx";
          args = [
            "-y"
            "chrome-devtools-mcp@latest"
            "--no-usage-statistics"
            "--executable-path=${pkgs.chromium}/bin/chromium"
            "--isolated"
            "--chromeArg=--ozone-platform=wayland"
            "--chromeArg=--no-first-run"
            "--chromeArg=--no-default-browser-check"
            "--chromeArg=--disable-search-engine-choice-screen"
            "--chrome-arg=--disable-blink-features=AutomationControlled"
          ];
          env_vars = [
            "WAYLAND_DISPLAY"
            "XDG_RUNTIME_DIR"
            "DBUS_SESSION_BUS_ADDRESS"
          ];
        };
        nixos = {
          command = "mcp-nixos";
        };
      };
    };
  };
}
