{
  description = "Home Manager configuration of luke";
  inputs = {
    nixpkgs = {
      url = "git+https://mirrors.nju.edu.cn/git/nixpkgs.git?ref=nixpkgs-unstable&shallow=1";
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
  };
  outputs =
    {
      nixpkgs,
      home-manager,
      nur,
      nixvim,
      sops-nix,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          nur.overlays.default
        ];
      };
    in
    {
      homeConfigurations = {
        luke = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [
            ./home.nix
            nixvim.homeModules.nixvim
            sops-nix.homeManagerModules.sops
          ];
        };
      };
      devShells = {
        x86_64-linux = {
          default = pkgs.mkShell {
            name = "Home-manager configuration";
            packages = with pkgs; [
              lua-language-server
              stylua
              yaml-language-server
            ];
          };
        };
      };
    };
}
