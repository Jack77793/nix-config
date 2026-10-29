{
  config,
  lib,
  pkgs,
  options,
  ...
}:

lib.mkIf config.custom.hostDefaults.enable {
  environment = {
    persistence."/nix/persist".directories = [
      "/var/lib/plocate"
    ];
    shellAliases = {
      locate = "locate --database /var/lib/plocate/plocate.db";
    };
  };

  services.locate = {
    enable = true;
    output = "/var/lib/plocate/plocate.db";
    package = pkgs.plocate;
    prunePaths = options.services.locate.prunePaths.default ++ [ "/home/.snapshots" ];
  };
}
