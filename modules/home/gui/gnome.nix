{ pkgs, ... }:

{

  programs.gnome-shell = {
    enable = true;
    extensions = [
      { package = pkgs.gnomeExtensions.appindicator; }
      { package = pkgs.gnomeExtensions.alphabetical-app-grid; }
      { package = pkgs.gnomeExtensions.caffeine; }
      { package = pkgs.gnomeExtensions.clipboard-indicator; }
      { package = pkgs.gnomeExtensions.gsconnect; }
      { package = pkgs.gnomeExtensions.screentospace; }
    ];
  };

  home = {
    packages = with pkgs; [ papirus-icon-theme ];

    pointerCursor = {
      enable = true;
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 32;
    };
  };

  qt = {
    enable = true;
    kvantum = {
      enable = true;
      settings = {
        General.theme = "KvArc";
      };
    };
    platformTheme.name = "adwaita";
    style.name = "kvantum";
  };

  services = {
    gnome-keyring.enable = true;
    mpris-proxy.enable = true;
  };
}
