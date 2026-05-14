{
  description = "Jack77793's NixOS config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "";
      inputs.home-manager.follows = "";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mySecrets = {
      url = "git+ssh://git@github.com/Jack77793/nix-secrets.git?shallow=1";
      flake = false;
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixfmt-rs.url = "github:Mic92/nixfmt-rs";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      myVars = import ./modules/vars.nix;
    in
    {
      nixosConfigurations = {
        Asanagi = nixpkgs.lib.nixosSystem {
          specialArgs = inputs // {
            inherit myVars;
          };
          modules = [
            ./hosts/asanagi
          ];
        };
      };
    };
}
