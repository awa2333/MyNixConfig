{
  config,
  pkgs,
  lib,
  ...
}:
let
  treesitter = pkgs.vimPlugins.nvim-treesitter.withPlugins (
    p: with p; [
      hyprlang
      yaml
      toml
      javascript
      bash
      nix
      python
      rust
      /*
        markdown
        markdown_inline
        lua
        c
        query
        vimdoc
        vim
      */
    ]
  );
in
{
  xdg.configFile = {
    "nvim/lua/chadrc.lua".source = config.lib.file.mkOutOfStoreSymlink ./src/nvim/chadrc.lua;
    "nvim/lua/configs.lua".source = config.lib.file.mkOutOfStoreSymlink ./src/nvim/configs.lua;
    "nvim/lua/lazy.lua".source = config.lib.file.mkOutOfStoreSymlink ./src/nvim/lazy.lua;
    "nvim/lua/plugins".source = config.lib.file.mkOutOfStoreSymlink ./src/nvim/plugins;
  };
  xdg.dataFile = {
    "nvim/treesitter/parser".source = "${
      pkgs.symlinkJoin {
        name = "treesitter-parsers";
        paths = (treesitter).dependencies;
      }
    }/parser";
    "nvim/plugins".source =
      if config.programs.neovim.enable then
        "${pkgs.symlinkJoin {
          name = "packDir";
          paths = [
            "${pkgs.vimUtils.packDir config.programs.neovim.finalPackage.passthru.packpathDirs}/pack/myNeovimPackages/start"
          ];
        }}"
      else
        ./nvim.nix;
  };
  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
      extraLuaConfig = lib.fileContents src/nvim/init.lua;
      extraPackages = with pkgs; [
        shfmt
        bash-language-server
        taplo
        lua-language-server
        python3
        lua51Packages.luarocks
        lua51Packages.lua
        stylua
        tree-sitter
        gcc
        wget
        nodejs
        nil
        fd
        biome
      ];
      plugins = with pkgs.vimPlugins; [
        better-escape-nvim
        yazi-nvim
        todo-comments-nvim
        rainbow-delimiters-nvim
        luasnip
        blink-cmp
        telescope-nvim
        nvim-autopairs
        friendly-snippets
        nvim-lspconfig
        mason-nvim
        gitsigns-nvim
        conform-nvim
        which-key-nvim
        nvim-tree-lua
        indent-blankline-nvim
        nvim-web-devicons
        nvzone-minty
        nvzone-menu
        nvzone-volt
        nvchad-ui
        base46
        plenary-nvim
        nvchad
        treesitter
        lazy-nvim
      ];
    };
    neovide = {
      enable = true;
      settings = {
        font = {
          normal = [ "JetBrainsMono Nerd Font" ];
          size = 11;
        };
      };
    };
  };
}
