{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf (config.currentNeovim == "neovim") {
    xdg = {
      configFile = {
        "nvim/lua/chadrc.lua" = {
          force = true;
          source = ./config/chadrc.lua;
        };
        "nvim/lua/configs.lua" = {
          force = true;
          source = ./config/configs.lua;
        };
        "nvim/lua/lazy-config.lua" = {
          force = true;
          source = ./config/lazy.lua;
        };
        "nvim/lua/plugins" = {
          force = true;
          source = ./plugins;
        };
      };
    };
    programs = {
      neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        defaultEditor = true;
        initLua = lib.fileContents ./init.lua;
        withRuby = false;
        withPython3 = false;
        extraPackages =
          with pkgs;
          [
            ripgrep
            tree-sitter
            shfmt
            bash-language-server
            taplo
            lua-language-server
            python3
            stylua
            gcc
            wget
            nodejs
            nil
            fd
            biome
          ]
          ++ (with lua51Packages; [
            luarocks
            lua
          ]);
        extraLuaPackages =
          luaPkgs: with luaPkgs; [
            jsregexp
          ];
        plugins = with pkgs.vimPlugins; [
          venv-selector-nvim
          typst-preview-nvim
          (nvim-treesitter.withAllGrammars)
          markdown-preview-nvim
          better-escape-nvim
          yazi-nvim
          todo-comments-nvim
          rainbow-delimiters-nvim
          blink-cmp
          nvim-autopairs
          friendly-snippets
          conform-nvim
          which-key-nvim
          nvim-tree-lua
          indent-blankline-nvim
          nvim-web-devicons
          nvzone-minty
          nvzone-menu
          nvzone-volt
          gitsigns-nvim
          luasnip
          mason-nvim
          nvim-lspconfig
          telescope-nvim
          nvchad-ui
          (nvchad.overrideAttrs {
            dependencies = with self; [
              gitsigns-nvim
              luasnip
              mason-nvim
              nvim-lspconfig
              telescope-nvim
              nvchad-ui
            ];
          })
          base46
          plenary-nvim
          lazy-nvim
        ];
      };
    };
  };
}
