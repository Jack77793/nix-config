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

  options.custom.development.enable = lib.mkEnableOption "extended development tools";

  config = {
    home-manager.users.${config.custom.mainUser} = {
      imports = [ ./git.nix ] ++ lib.optional config.custom.development.enable ./uv.nix;
    }
    // lib.optionalAttrs (_class == "nixos") {
      custom.development.python.extraPackages = lib.mkAfter (
        ps:
        lib.optionals (config.custom.development.enable && config.custom.desktop.enable) [
          ps.secretstorage
        ]
      );
    };
  }
  // lib.optionalAttrs (_class == "nixos") {
    environment.systemPackages = [ pkgs.git ];
  };
}
