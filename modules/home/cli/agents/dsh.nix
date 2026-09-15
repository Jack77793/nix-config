{
  config,
  osConfig,
  lib,
  pkgs,
  ...
}:

lib.mkIf osConfig.custom.desktop.enable {
  home = {
    packages = with pkgs; [ dsh ];

    file = {
      ".dsh/skills/humanizer".source = "${pkgs.humanizer}/humanizer";
      ".dsh/skills/humanizer-zh".source = "${pkgs.humanizer-zh}/humanizer-zh";
      ".dsh/skills/doc-coauthoring".source = "${pkgs.anthropics-skills}/doc-coauthoring";
      ".dsh/skills/docx".source = "${pkgs.anthropics-skills}/docx";
      ".dsh/skills/pdf".source = "${pkgs.anthropics-skills}/pdf";
      ".dsh/skills/pptx".source = "${pkgs.anthropics-skills}/pptx";
      ".dsh/skills/xlsx".source = "${pkgs.anthropics-skills}/xlsx";
    };
  };
}
