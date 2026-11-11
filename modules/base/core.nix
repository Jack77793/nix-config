{
  config,
  lib,
  _class,
  agenix,
  impermanence,
  lanzaboote,
  ...
}:

{
  imports = lib.optionals (_class == "nixos") [
    agenix.nixosModules.default
    impermanence.nixosModules.impermanence
    lanzaboote.nixosModules.lanzaboote
  ];

  options.custom.hostDefaults.enable =
    lib.mkEnableOption "shared platform and Nix maintenance defaults"
    // {
      default = true;
    };

  options.custom.stateVersion = lib.mkOption {
    type = lib.types.nonEmptyStr;
    description = "The Home Manager state version, also applied to the system on NixOS";
  };

  config = lib.mkMerge [
    {
      home-manager.users.${config.custom.mainUser}.home.stateVersion = config.custom.stateVersion;
    }
    (lib.optionalAttrs (_class == "nixos") {
      system.stateVersion = config.custom.stateVersion;
    })
  ];
}
