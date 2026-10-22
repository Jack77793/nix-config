{
  config,
  lib,
  pkgs,
  ...
}:

{
  custom.development.neovim.extended = lib.mkDefault true;

  home-manager.users.${config.custom.mainUser} = {
    programs = {
      neovim.extraPackages = [ pkgs.nixfmt ];

      codex = {
        enableMcpIntegration = false;
        settings.mcp_servers = lib.mkForce { };
      };
      mcp = {
        enable = lib.mkForce false;
        servers = lib.mkForce { };
      };
    };
  };
}
