{ config, lib, ... }:

{
  home-manager.users.${config.custom.mainUser} = {
    imports = [
      ../../home/modules/development/python.nix
    ]
    ++ lib.optional config.custom.desktop.enable ../../home/modules/development/uv.nix;

    custom.development.python.extraPackages = lib.mkAfter (
      ps: lib.optionals config.custom.desktop.enable [ ps.secretstorage ]
    );
  };
}
