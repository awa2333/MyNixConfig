{
  inputs = {
    nixpkgs = {
      url = "git+https://mirrors.tuna.tsinghua.edu.cn/git/nixpkgs.git?ref=nixos-unstable&shallow=1";
    };
    nur = {
      url = "github:nix-community/NUR";
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
      nur,
      ...
    }:
    {
      nixosConfigurations = {
        NixOS = nixpkgs.lib.nixosSystem {
          modules = [
            ./configuration.nix
            nur.modules.nixos.default
          ];
        };
      };
    };
}
