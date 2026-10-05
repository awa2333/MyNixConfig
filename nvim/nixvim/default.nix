{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.currentNeovim == "nixvim") {
    xdg.configFile = {
      "nvim/lua/chadrc.lua" = {
        source = ./chadrc.lua;
      };
    };
    programs = {
      nixvim =
        let
          helpers = config.lib.nixvim;
        in
        {
          enable = true;
          defaultEditor = true;
          viAlias = true;
          vimAlias = true;
          extraPackages =
            with pkgs;
            [
              nil
              python3
              ripgrep
              lua5_1
            ]
            ++ (with pkgs.lua51Packages; [
              jsregexp
              tree-sitter-cli
              luarocks
            ]);
          globals = {
            mapleader = " ";
            base46_cache = helpers.mkRaw "vim.fn.stdpath(\"data\") .. \"/base46/\"";
          };
          opts = {
            relativenumber = true;
          };
          extraConfigLuaPre = ''
            if not vim.loop.fs_stat(vim.g.base46_cache) then
            	require("base46").load_all_highlights()
            end
          '';
          extraConfigLuaPost = ''
            dofile(vim.g.base46_cache .. "defaults")
            dofile(vim.g.base46_cache .. "statusline")
            require("nvchad.options")
            require("nvchad.autocmds")
            vim.schedule(function()
              require "nvchad.mappings"
            end)

          '';
          lsp = {
            servers = {
              nil_ls = {
                enable = true;
              };
              basedpyright = {
                enable = true;
              };
            };
          };
          plugins = {
            lazy = {
              enable = true;
              autoLoad = true;
              plugins = with pkgs.vimPlugins; [
                telescope-nvim
                mason-nvim
                blink-cmp
                base46
                friendly-snippets
                indent-blankline-nvim
                nvzone-menu
                nvzone-minty
                nvzone-volt
                nvim-autopairs
                nvim-tree-lua
                nvim-web-devicons
                plenary-nvim
                which-key-nvim
                gitsigns-nvim
              ];
              settings = with pkgs.vimPlugins; {
                spec = [
                  {
                    name = lib.getName nvim-lspconfig;
                    dir = "${nvim-lspconfig}";
                    config =
                      let
                        servers = builtins.concatStringsSep "," (
                          builtins.map (a: "\"" + a + "\"") [
                            "rumdl"
                            "markdown_oxide"
                            "bashls"
                            "tinymist"
                            "taplo"
                            "ruff"
                            "biome"
                            "nil_ls"
                            "lua_ls"
                            "basedpyright"
                            "yamlls"
                          ]
                        );
                      in
                      helpers.mkRaw ''
                        function()
                          require("nvchad.configs.lspconfig").defaults()
                          vim.lsp.enable({${servers}})
                        end
                      '';
                  }
                  {
                    name = lib.getName nvim-treesitter;
                    dir = "${nvim-treesitter}";
                    dependencies = [
                      {
                        name = lib.getName rainbow-delimiters-nvim;
                        dir = "${rainbow-delimiters-nvim}";
                      }
                    ];
                    opts = {
                      auto_install = false;
                    };
                  }
                  {
                    name = lib.getName todo-comments-nvim;
                    dir = "${todo-comments-nvim}";
                    event = "User FilePost";
                  }
                  {
                    name = lib.getName conform-nvim;
                    dir = "${conform-nvim}";
                    event = "BufWritePre";
                    opts = {
                      formatters_by_ft = {
                        markdown = [ "rumdl" ];
                        typst = [ "typstyle" ];
                        lua = [ "stylua" ];
                        nix = [ "nixfmt" ];
                        javascript = [ "biome" ];
                        bash = [ "shfmt" ];
                      };
                      format_on_save = {
                        timeout_ms = 500;
                        lsp_fallback = true;
                      };

                    };
                  }
                  {
                    name = lib.getName better-escape-nvim;
                    dir = "${better-escape-nvim}";
                    event = [
                      "CmdLineEnter"
                      "InsertEnter"
                    ];
                    opts = {
                      timeout = helpers.mkRaw "vim.o.timeoutlen";
                      default_mappings = true;
                      mappings = {
                        i = {
                          j = {
                            k = "<Esc>";
                          };
                        };
                        c = {
                          j = {
                            k = "C-c";
                          };
                        };
                      };
                    };
                  }
                  {
                    name = "LuaSnip";
                    dir = "${luasnip}";
                  }
                  {
                    name = lib.getName nvchad;
                    dir = "${nvchad.overrideAttrs {
                      dependencies = with self; [
                        gitsigns-nvim
                        luasnip
                        mason-nvim
                        nvim-lspconfig
                        telescope-nvim
                        nvchad-ui
                      ];
                    }}";
                    lazy = false;
                    import = "nvchad.plugins";
                  }
                  {
                    name = "ui";
                    dir = "${nvchad-ui}";
                  }
                  {
                    import = "nvchad.blink.lazyspec";
                  }
                ];
                defaults = {
                  lazy = true;
                };
                install = {
                  colorscheme = [
                    "nvchad"
                  ];
                };
                change_detection = {
                  notify = false;
                };
                install = {
                  missing = false;
                };
                ui = {
                  icons = {
                    ft = "";
                    lazy = "󰂠 ";
                    loaded = "";
                    not_loaded = "";
                  };
                };
                performance = {
                  reset_packpath = true;
                  rtp = {
                    reset = true;
                    disabled_plugins = [
                      "2html_plugin"
                      "tohtml"
                      "getscript"
                      "getscriptPlugin"
                      "gzip"
                      "logipat"
                      "netrw"
                      "netrwPlugin"
                      "netrwSettings"
                      "netrwFileHandlers"
                      "matchit"
                      "tar"
                      "tarPlugin"
                      "rrhelper"
                      "spellfile_plugin"
                      "vimball"
                      "vimballPlugin"
                      "zip"
                      "zipPlugin"
                      "tutor"
                      "rplugin"
                      "syntax"
                      "synmenu"
                      "optwin"
                      "compiler"
                      "bugreport"
                      "ftplugin"
                    ];
                  };
                };
              };
            };
          };
        };
    };
  };
}
