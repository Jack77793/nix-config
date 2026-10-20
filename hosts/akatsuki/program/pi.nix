{ lib, ... }:

{
  imports = [ ../../../home/modules/development/agents/pi.nix ];

  programs.mcp = {
    enable = lib.mkForce false;
    servers = lib.mkForce { };
  };
}
