{
  config,
  pkgs,
  options,
  ...
}:

{
  environment = {
    persistence."/nix/persist".directories = [
      "/var/lib/plocate"
    ];
    shellAliases = {
      locate = "locate --database /var/lib/plocate/plocate.db";
    };
  };

  home-manager.users.${config.custom.mainUser} = {
    imports = [ ../../home/modules/terminal/tools.nix ];
    programs.ripgrep-all.enable = config.custom.desktop.enable;
  };

  services.locate = {
    enable = true;
    output = "/var/lib/plocate/plocate.db";
    package = pkgs.plocate;
    prunePaths = options.services.locate.prunePaths.default ++ [ "/home/.snapshots" ];
  };
}
