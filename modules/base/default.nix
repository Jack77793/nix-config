{ _class, lib, ... }:

{
  imports = [
    ./core.nix
    ./users.nix
    ./home-manager.nix
  ]
  ++ lib.optionals (_class == "nixos") [
    ./profiles.nix
  ];
}
