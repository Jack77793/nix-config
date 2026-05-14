{ pkgs, ... }:

{
  xdg = {
    mime = {
      addedAssociations = {
        "text/*" = "nvim.desktop";
      };
      defaultApplications = {
        "text/*" = "nvim.desktop";
        "image/*" = "org.gnome.Loupe.desktop";
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
