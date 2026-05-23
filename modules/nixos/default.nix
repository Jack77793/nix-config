{ impermanence, ... }:

{
  imports = [
    impermanence.nixosModules.impermanence
    ./base
    ./desktop
    ./extras
  ];
}
