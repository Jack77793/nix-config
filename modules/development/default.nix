{
  config,
  lib,
  pkgs,
  _class,
  ...
}:

{
  imports = [
    ./neovim
    ./agents
  ];

  home-manager.users.${config.custom.mainUser} = {
    imports = [ ./git.nix ] ++ lib.optional config.custom.desktop.enable ./uv.nix;
  }
  // lib.optionalAttrs (_class == "nixos") {
    custom.development.python.extraPackages = lib.mkAfter (
      ps: lib.optionals config.custom.desktop.enable [ ps.secretstorage ]
    );
  };
}
// lib.optionalAttrs (_class == "nixos") {
  environment.systemPackages = [ pkgs.git ];
}
