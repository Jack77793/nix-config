{
  description = "Jack77793's NixOS config";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      treefmt-nix,
      ...
    }@inputs:
    let
      eachSystem = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      treefmtEval = eachSystem (
        system: treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} ./treefmt.nix
      );
    in
    {
      nixosConfigurations = {
        Akashi = nixpkgs.lib.nixosSystem {
          specialArgs = inputs;
          modules = [
            ./hosts/akashi
          ];
        };
        Akitsushima = nixpkgs.lib.nixosSystem {
          specialArgs = inputs;
          modules = [
            ./modules
            ./hosts/akitsushima
          ];
        };
        Amagi = nixpkgs.lib.nixosSystem {
          specialArgs = inputs;
          modules = [
            ./modules
            ./hosts/amagi
          ];
        };
        Asanagi = nixpkgs.lib.nixosSystem {
          specialArgs = inputs;
          modules = [
            ./modules
            ./hosts/asanagi
          ];
        };
        Asuka = nixpkgs.lib.nixosSystem {
          specialArgs = inputs;
          modules = [
            ./hosts/asuka
          ];
        };
      };

      darwinConfigurations.Akatsuki = nix-darwin.lib.darwinSystem {
        specialArgs = inputs;
        modules = [
          ./modules
          ./hosts/akatsuki
        ];
      };

      packages.x86_64-linux = (import ./pkgs).packages {
        inherit nixpkgs;
        system = "x86_64-linux";
      };

      formatter = eachSystem (system: treefmtEval.${system}.config.build.wrapper);
    };
}
