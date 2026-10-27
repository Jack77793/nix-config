{ lib, pkgs, ... }:

{
  home.packages = [ pkgs.texliveFull ];

  programs.foliate = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    enable = true;
    settings = {
      "library".view-mode = "list";
      "viewer/font".minimum-size = 24;
      "window".maximized = true;
    };
  };

  programs.pandoc = {
    enable = true;
    templates = {
      "eisvogel.beamer" = "${pkgs.eisvogel-template}/share/eisvogel.beamer";
      "eisvogel.latex" = "${pkgs.eisvogel-template}/share/eisvogel.latex";
    };
  };
}
