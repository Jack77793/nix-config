{
  config,
  lib,
  pkgs,
  ...
}:

{
  home.packages =
    lib.optionals (builtins.hasAttr "nixos" (config.programs.codex.settings.mcp_servers or { }))
      (
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
      mcp_servers.nixos.command = "mcp-nixos";
    };
  };
}
