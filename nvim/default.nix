{
  config,
  pkgs,
  lib,
  ...
}:
{
  xdg = {
    configFile = {
      "nvim/lua/chadrc.lua" = {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink ./config/chadrc.lua;
      };
      "nvim/lua/configs.lua" = {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink ./config/configs.lua;
      };
      "nvim/lua/lazy-config.lua" = {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink ./config/lazy.lua;
      };
      "nvim/lua/plugins" = {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink ./plugins;
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
      extraPackages =
        with pkgs;
        [
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
      plugins =
        let
          myPlugins = with pkgs.vimPlugins; [
            typst-preview-nvim
            (nvim-treesitter.withPlugins (
              p: with p; [
                typst
                nix
                python
                yaml
                toml
                bash
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
            ))
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
          lazyLoad =
            let
              lazyFunc = x: {
                plugin = x;
                optional = true;
              };
            in
            x: map (x: lazyFunc x) x;
        in
        (lazyLoad myPlugins) ++ [ ];
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
