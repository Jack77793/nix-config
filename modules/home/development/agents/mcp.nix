{
  config,
  lib,
  pkgs,
  ...
}:

let
  enabled = config.programs.mcp.enable;
in
{
  programs.mcp = {
    enable = lib.mkDefault pkgs.stdenv.hostPlatform.isLinux;
    servers = lib.mkIf enabled {
      nixos.command = "mcp-nixos";
    };
  };

  home.packages = lib.optionals (enabled && config.programs.codex.enable) (
    with pkgs;
    [
      mcp-nixos
      nodejs
    ]
  );

  programs.codex.settings.mcp_servers = lib.mkIf (enabled && config.programs.codex.enable) {
    nixos.command = "mcp-nixos";
  };

  programs.pi-coding-agent = {
    extraPackages = lib.optionals (enabled && config.programs.pi-coding-agent.enable) [
      pkgs.mcp-nixos
    ];
    settings.packages = lib.optionals (enabled && config.programs.pi-coding-agent.enable) [
      "npm:pi-mcp-adapter"
    ];
  };
}
