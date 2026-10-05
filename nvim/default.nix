{ lib, ... }:
{
  imports = [
    ./neovim
  ];
  options = {
    currentNeovim = lib.mkOption {
      default = "neovim";
      type = lib.types.enum [
        "neovim"
        "nixvim"
      ];
    };
  };
  config = {
    currentNeovim = "neovim";
  };
}
