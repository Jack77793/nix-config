{
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
    ./base
    ./desktop
    ./extras
  ];
}
