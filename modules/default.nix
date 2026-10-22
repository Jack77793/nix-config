{ _class, home-manager, ... }:

{
  imports = [
    ./common
  ]
  ++ (
    if _class == "nixos" then
      [
        home-manager.nixosModules.home-manager
        ./nixos
      ]
    else if _class == "darwin" then
      [
        home-manager.darwinModules.home-manager
        ./darwin
      ]
    else
      throw "Unsupported module class: ${toString _class}"
  );
}
