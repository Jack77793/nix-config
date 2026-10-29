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

  options.custom.hostDefaults.enable =
    lib.mkEnableOption "shared boot, hardware, storage, networking and Nix maintenance defaults"
    // {
      default = true;
    };

  options.custom.stateVersion = lib.mkOption {
    type = lib.types.nonEmptyStr;
    description = "The state version of host, will be applied to system and home-manager";
  };

  config = {
    system.stateVersion = config.custom.stateVersion;
    home-manager.users.${config.custom.mainUser}.home.stateVersion = config.custom.stateVersion;
  };
}
