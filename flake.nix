{
  outputs =
    {
      self,
      stylix,
      nixpkgs,
      home-manager,
      sops-nix,
      nixvim,
      nur,
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
        };
      };
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          { nixpkgs.overlays = [ self.overlays.default ]; }
          ./configuration.nix
          sops-nix.nixosModules.sops
          nur.modules.nixos.default
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.luke = ./homemanagerModule;
            home-manager.sharedModules = [
              nixvim.homeModules.nixvim
            ];
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
