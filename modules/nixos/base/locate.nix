{ pkgs, options, ... }:

{
  services.locate = {
    enable = true;
    package = pkgs.plocate;
    output = "/var/lib/plocate/plocate.db";
    prunePaths = options.services.locate.prunePaths.default ++ [ "/home/.snapshots" ];
  };

  environment.shellAliases = {
    locate = "locate --database /var/lib/plocate/plocate.db";
  };

  environment.persistence."/nix/persist".directories = [
    "/var/lib/plocate"
  ];
}
