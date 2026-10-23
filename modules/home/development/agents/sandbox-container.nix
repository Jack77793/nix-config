{
  config,
  piAuthPath,
  piSandboxSessionsDir,
  piSandboxPackagesDir,
  ...
}:

let
  piConfigDir = config.programs.pi-coding-agent.configDir;
in
{
  home.file = {
    "${piConfigDir}/sessions".source = config.lib.file.mkOutOfStoreSymlink piSandboxSessionsDir;
    "${piConfigDir}/auth.json".source = config.lib.file.mkOutOfStoreSymlink piAuthPath;
    "${piConfigDir}/npm".source = config.lib.file.mkOutOfStoreSymlink "${piSandboxPackagesDir}/npm";
    "${piConfigDir}/git".source = config.lib.file.mkOutOfStoreSymlink "${piSandboxPackagesDir}/git";
  };
}
