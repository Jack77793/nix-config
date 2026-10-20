{ lib, ... }:

{
  imports = [ ../../../home/modules/development/agents/codex.nix ];

  programs.codex = {
    enableMcpIntegration = false;
    settings.mcp_servers = lib.mkForce { };
  };
}
