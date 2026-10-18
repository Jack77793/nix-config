{
  config,
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

  _module.args = {
    myVars = import ./vars.nix;
  };
  nixpkgs.overlays = import ../../pkgs;
  system.stateVersion = config.custom.stateVersion;
}
