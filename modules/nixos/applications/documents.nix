{ config, lib, ... }:

lib.mkIf config.custom.desktop.enable {
  home-manager.users.${config.custom.mainUser} = {
    programs.foliate = {
      enable = true;
      settings = {
        "library".view-mode = "list";
        "viewer/font".minimum-size = 24;
        "window".maximized = true;
      };
    };
  };
}
