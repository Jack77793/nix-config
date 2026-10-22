{ pkgs, ... }:

{
  home.packages = [ pkgs.texliveFull ];

  programs.pandoc = {
    enable = true;
    templates = {
      "eisvogel.beamer" = "${pkgs.eisvogel-template}/share/eisvogel.beamer";
      "eisvogel.latex" = "${pkgs.eisvogel-template}/share/eisvogel.latex";
    };
  };
}
