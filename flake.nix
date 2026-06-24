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

    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
      ...
    }@inputs:
    let
      eachSystem =
        f:
        nixpkgs.lib.genAttrs (builtins.attrNames nixpkgs.legacyPackages) (
          system: f nixpkgs.legacyPackages.${system}
        );

      treefmtEval = eachSystem (
        pkgs:
        treefmt-nix.lib.evalModule pkgs {
          projectRootFile = "flake.nix";
          programs.nixfmt.enable = true;
          programs.prettier.enable = true;
          programs.shfmt.enable = true;
          programs.stylua.enable = true;
          settings.global.excludes = [ "result/*" ];
        }
      );
    in
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

      formatter = eachSystem (pkgs: treefmtEval.${pkgs.stdenv.hostPlatform.system}.config.build.wrapper);
    };
}
