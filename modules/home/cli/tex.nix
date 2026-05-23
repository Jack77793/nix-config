{
  osConfig,
  lib,
  pkgs,
  myPkgs,
  ...
}:

lib.mkIf osConfig.custom.desktop.enable {
  programs.pandoc = {
    enable = true;
    templates = {
      "eisvogel.latex" = "${myPkgs.eisvogel-template}/share/eisvogel.latex";
      "eisvogel.beamer" = "${myPkgs.eisvogel-template}/share/eisvogel.beamer";
    };
  };

  home.packages = with pkgs; [
    texliveFull
  ];
}
