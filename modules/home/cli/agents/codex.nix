{
  osConfig,
  lib,
  pkgs,
  ...
}:

lib.mkIf osConfig.custom.desktop.enable {
  home.packages = with pkgs; [
    mcp-nixos
  ];

  programs.codex = {
    enable = true;
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
  };
}
