{ _class, lib, ... }:

{
  imports = [
    ./users.nix
    ./home-manager.nix
  ]
  ++ lib.optionals (_class == "nixos") [
    ./core.nix
    ./profiles.nix
  ];
}
