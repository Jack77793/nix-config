{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./mcp.nix
    ./pi.nix
  ];

  home-manager.users.${config.custom.mainUser}.home.packages = lib.mkIf config.custom.desktop.enable [
    pkgs.bubblewrap
  ];
}
