{ config, lib, ... }:

{
  home-manager.users.${config.custom.mainUser} = {
    custom.development.python.extraPackages = lib.mkAfter (
      ps: lib.optionals config.custom.desktop.enable [ ps.secretstorage ]
    );
  };
}
