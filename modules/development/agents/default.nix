{
  config,
  lib,
  pkgs,
  _class,
  ...
}:

{
  options.custom.development.agents.enable = lib.mkEnableOption "AI coding agents";

  config.home-manager.users.${config.custom.mainUser} = {
    imports = lib.optional config.custom.development.agents.enable ./home.nix;
    home.packages = lib.optionals (config.custom.development.agents.enable && _class == "nixos") [
      pkgs.bubblewrap
    ];
  };
}
