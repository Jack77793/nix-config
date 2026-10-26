{ lib, pkgs, ... }:

{
  home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux (
    with pkgs;
    [
      mcp-nixos
      nodejs
    ]
  );

  programs.codex = {
    enable = true;
    mutableSettings = true;
    context = ./AGENTS.md;
    skills = import ./skills.nix { inherit pkgs; };
    settings = {
      mcp_servers = lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
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
    };
  };
}
