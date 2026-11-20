{ pkgs, ... }:

{
  programs.antigravity-cli = {
    enable = true;
    enableMcpIntegration = true;
    context.GEMINI = ./AGENTS.md;
    mutableSettings = true;
    permissions.deny = [ "command(rm -rf)" ];
    settings = {
      copyOnSelect = false;
      showFeedbackSurvey = false;
      toolPermission = "always-proceed";
    };
    skills = import ./skills.nix { inherit pkgs; };
  };
}
