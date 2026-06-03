{
  description = "Home Manager configuration of luke";
  inputs = {
    self = {
      submodules = true;
    };
    nixpkgs = {
      url = "git+https://mirrors.nju.edu.cn/git/nixpkgs.git?ref=nixos-unstable&shallow=1";
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
    local = {
      url = ./local;
      flake = false;
    };
  };
  outputs =
    {
      nixpkgs,
      home-manager,
      nur,
      local,
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
            local.outPath
          ];
        };
      };
      devShells = {
        x86_64-linux = {
          default = pkgs.mkShell {
            name = "Home-manager configuration";
            packages = with pkgs; [
              kdlfmt
              lua-language-server
              stylua
            ];
          };
        };
      };
    };
}
