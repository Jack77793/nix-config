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
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        Asanagi = nixpkgs.lib.nixosSystem {
          specialArgs = inputs;
          modules = [
            ./modules
            ./hosts/asanagi
          ];
        };
        Akashi = nixpkgs.lib.nixosSystem {
          specialArgs = inputs;
          modules = [
            ./hosts/akashi
          ];
        };
      };
    };
}
