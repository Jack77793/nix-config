{
  config,
  lib,
  ...
}:

let
  cfg = config.custom.development.agentSandbox;
  piConfigDir = config.programs.pi-coding-agent.configDir;
in
{
  options.custom.development.agentSandbox.container = {
    sessionsDir = lib.mkOption {
      type = lib.types.nonEmptyStr;
      description = "Runtime path to the writable Pi sessions mount in the container";
    };
    packagesDir = lib.mkOption {
      type = lib.types.nonEmptyStr;
      description = "Runtime path to the read-only host Pi packages mount in the container";
    };
  };

  config.home.file = {
    "${piConfigDir}/sessions".source = config.lib.file.mkOutOfStoreSymlink cfg.container.sessionsDir;
    "${piConfigDir}/auth.json".source = config.lib.file.mkOutOfStoreSymlink cfg.authPath;
    "${piConfigDir}/npm".source =
      config.lib.file.mkOutOfStoreSymlink "${cfg.container.packagesDir}/npm";
    "${piConfigDir}/git".source =
      config.lib.file.mkOutOfStoreSymlink "${cfg.container.packagesDir}/git";
  };
}
