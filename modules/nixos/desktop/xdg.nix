{ pkgs, ... }:

{
  xdg = {
    mime = {
      addedAssociations = {
        "text/*" = "nvim.desktop";
        "audio/midi" = "org.gnome.Decibels.desktop";
      };
      defaultApplications = {
        "audio/*" = "org.gnome.Decibels.desktop";
        "image/*" = "org.gnome.Loupe.desktop";
        "text/*" = "nvim.desktop";
        "video/*" = "mpv.desktop";

        "application/json" = "nvim.desktop";
        "application/x-desktop" = "nvim.desktop";
        "application/x-shellscript" = "nvim.desktop";
        "application/xml" = "nvim.desktop";
        "application/yaml" = "nvim.desktop";

        "application/*-compressed-tar" = "org.gnome.FileRoller.desktop";
        "application/java-archive" = "org.gnome.FileRoller.desktop";
        "application/vnd.rar" = "org.gnome.FileRoller.desktop";
        "application/x-7z-compressed" = "org.gnome.FileRoller.desktop";
        "application/x-rpm" = "org.gnome.FileRoller.desktop";
        "application/zip" = "org.gnome.FileRoller.desktop";

        "application/epub+zip" = "com.github.johnfactotum.Foliate.desktop";
        "application/pdf" = "org.gnome.Evince.desktop";
        "application/x-musescore" = "org.musescore.MuseScore.desktop";
        "text/x-bibtex" = "org.gnome.World.Citations.desktop";
      };
    };
    portal = {
      enable = true;
      configPackages = [ pkgs.gnome-session ];
      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
      ];
      xdgOpenUsePortal = true;
    };
    terminal-exec = {
      enable = true;
      settings.default = [ "com.mitchellh.ghostty.desktop" ];
    };
  };

  environment.pathsToLink = [
    "/share/xdg-desktop-portal"
    "/share/applications"
  ];
}
