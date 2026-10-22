{ pkgs, ... }:

{
  imports = [ ./mcp.nix ];

  programs.codex = {
    enable = true;
    mutableSettings = true;
    context = ./AGENTS.md;
    skills = import ./skills.nix { inherit pkgs; };
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
    };
  };
}
