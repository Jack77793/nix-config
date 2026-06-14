{
  osConfig,
  lib,
  pkgs,
  ...
}:

lib.mkIf osConfig.custom.desktop.enable {
  programs.pandoc = {
    enable = true;
    templates = {
      "eisvogel.latex" = "${pkgs.eisvogel-template}/share/eisvogel.latex";
      "eisvogel.beamer" = "${pkgs.eisvogel-template}/share/eisvogel.beamer";
    };
  };

  home.packages = with pkgs; [
    texliveFull
  ];
}
