{ config, lib, ... }:

lib.mkIf config.custom.desktop.enable {
  home-manager.users.${config.custom.mainUser} =
    { config, lib, ... }:
    {
      imports = [ ../../../home/development/agents/chrome-devtools.nix ];

      home.activation = lib.mkIf (config.programs.mcp.enable && config.programs.pi-coding-agent.enable) {
        pi-mcp-sync = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          rm -f ${config.programs.pi-coding-agent.configDir}/mcp.json
        '';
      };
    };
}
