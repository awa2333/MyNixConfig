{
  outputs =
    {
      self,
      nixos-hardware,
      stylix,
      nixpkgs,
      home-manager,
      sops-nix,
      nixvim,
      nur,
      nix-index-database,
      devenv,
      systems,
      ...
    }@inputs:
    let
      forEachSystem = nixpkgs.lib.genAttrs (import systems);
    in
    {
      overlays = {
        default = final: prev: {
          miscFiles = final.callPackage ./misc.nix { };
          inherit (prev.lixPackageSets.stable)
            nixpkgs-revew
            nix-eval-jobs
            nix-fast-build
            colmena
            ;
        };
      };
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          { nixpkgs.overlays = [ self.overlays.default ]; }
          ./configuration.nix
          nixos-hardware.nixosModules.asus-fa507rm
          sops-nix.nixosModules.sops
          nur.modules.nixos.default
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              extraSpecialArgs = { inherit inputs; };
              users.luke = ./homemanagerModule;
              sharedModules = [
                nixvim.homeModules.nixvim
                nix-index-database.homeModules.default
              ];
            };
          }
        ];
      };
      devShells = forEachSystem (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = devenv.lib.mkShell {
            inherit inputs pkgs;
            modules = [
              {
                env = {
                  DEVENV_SKIP_TASKS = 1;
                };
              }
            ];
          };
        }
      );
    };
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    nixvim = {
      url = "github:nix-community/nixvim";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };

    systems = {
      url = "github:nix-systems/default";
    };
    devenv = {
      url = "github:cachix/devenv";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
  };
}
