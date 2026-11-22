{
  config,
  lib,
  pkgs,
  _class,
  ...
}:

let
  isNixosAgents = config.custom.development.agents.enable && _class == "nixos";
in
{
  options.custom.development.agents.enable = lib.mkEnableOption "AI coding agents";

  config = {
    assertions = [
      {
        assertion = !config.custom.development.agents.enable || _class == "nixos";
        message = "custom.development.agents.enable is only supported on NixOS (Linux) hosts.";
      }
      {
        assertion = !config.custom.development.agents.enable || config.custom.development.enable;
        message = "custom.development.agents.enable requires custom.development.enable.";
      }
    ];

    home-manager.users.${config.custom.mainUser} = {
      imports = lib.optional isNixosAgents ./home.nix;
      home.packages = lib.optionals isNixosAgents [
        pkgs.bubblewrap
      ];
    };
  };
}
