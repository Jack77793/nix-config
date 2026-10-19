{
  config,
  lib,
  pkgs,
  ...
}:

lib.mkIf config.custom.desktop.enable {
  home-manager.users.${config.custom.mainUser}.imports = [
    {
      home.packages = with pkgs; [
        texliveFull
      ];

      programs = {
        foliate = {
          enable = true;
          settings = {
            "library".view-mode = "list";
            "viewer/font".minimum-size = 24;
            "window".maximized = true;
          };
        };

        pandoc = {
          enable = true;
          templates = {
            "eisvogel.beamer" = "${pkgs.eisvogel-template}/share/eisvogel.beamer";
            "eisvogel.latex" = "${pkgs.eisvogel-template}/share/eisvogel.latex";
          };
        };
      };
    }
  ];
}
