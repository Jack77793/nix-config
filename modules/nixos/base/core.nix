{
  config,
  lib,
  agenix,
  impermanence,
  lanzaboote,
  ...
}:

{
  imports = [
    agenix.nixosModules.default
    impermanence.nixosModules.impermanence
    lanzaboote.nixosModules.lanzaboote
  ];

  options.custom.stateVersion = lib.mkOption {
    type = lib.types.nonEmptyStr;
    description = "The state version of host, will be applied to system and home-manager";
  };

  config = {
    system.stateVersion = config.custom.stateVersion;
  };
}
