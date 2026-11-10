{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.currentNeovim == "nixvim") {
    programs = {
      nixvim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        defaultEditor = true;
        extraPackages = with pkgs; [
          mermaid-cli
          tectonic
          ripgrep
          tree-sitter
          nixfmt
          deadnix
          statix
          ghostscript_headless
        ];
        globals = {
          mapleader = " ";
        };
        opts = {
          number = true;
          relativenumber = true;
          shiftwidth = 2;
          expandtab = true;
          undofile = true;
          cursorline = true;
          hlsearch = false;
          incsearch = true;
          signcolumn = "yes";
        };
        keymaps = [
          {
            mode = [ "n" ];
            key = "<leader>-";
            action = ":lua require('oil').toggle_float()<CR>";
            options = {
              desc = "Open Oil Float";
            };
          }
          {
            mode = [ "n" ];
            key = "<leader>e";
            action = ":lua Snacks.explorer()<CR>";
            options = {
              desc = "File Explorer";
            };
          }
          {
            mode = [ "n" ];
            key = "<leader>.";
            action = ":lua Snacks.scratch()<CR>";
            options = {
              desc = "Toggle Scratch Buffer";
            };
          }
          {
            mode = "n";
            key = "<leader>z";
            action = ":lua Snacks.zen()<CR>";
            options = {
              desc = "Toggle Zen Mode";
            };
          }
          {
            mode = "n";
            key = "<leader>Z";
            action = ":lua Snacks.zen.zoom()<CR>";
            options = {
              desc = "Toggle Zoom";
            };
          }
        ];
        plugins = {
          lsp = {
            enable = true;
            servers = {
              nixd = {
                enable = true;
              };
              hls = {
                enable = true;
                package = null;
                installGhc = false;
              };
            };
          };
          lint = {
            enable = true;
            lintersByFt = {
              nix = [
                "deadnix"
                "statix"
              ];
            };
          };
          which-key = {
            enable = true;
          };
          blink-cmp = {
            enable = true;
            settings = {
              signature = {
                enabled = true;
              };
              keymap = {
                preset = "none";
                "<CR>" = [
                  "accept"
                  "fallback"
                ];
                "<Tab>" = [
                  "select_next"
                  "snippet_forward"
                  "fallback"
                ];
                "<S-Tab>" = [
                  "select_prev"
                  "snippet_backward"
                  "fallback"
                ];
              };
              sources = {
                default = [
                  "lsp"
                  "path"
                  "snippets"
                  "buffer"
                  "ripgrep"
                ];
                providers = {
                  ripgrep = {
                    module = "blink-ripgrep";
                    name = "Ripgrep";
                  };
                };
              };
            };
          };
          blink-pairs = {
            enable = true;
          };
          blink-ripgrep = {
            enable = true;
          };
          treesitter = {
            enable = true;
            grammarPackages =
              with config.programs.nixvim.plugins.treesitter.package.builtGrammars;
              [
                css
                html
                javascript
                latex
                scss
                svelte
                tsx
                typst
                vue
                regex

                haskell
                python
                nix
              ]
              ++ [
                pkgs.tree-sitter-grammars.tree-sitter-norg
              ];
            highlight = {
              enable = true;
            };
          };
          better-escape = {
            enable = true;
          };
          lsp-lines = {
            enable = true;
          };
          conform-nvim = {
            enable = true;
            autoInstall = {
              enable = false;
            };
            settings = {
              formatters_by_ft = {
                nix = [ "nixfmt" ];
                haskell = [ "fourmolu" ];
              };
              format_on_save = {
                timeout_ms = 500;
                lsp_format = "fallback";
              };
            };
          };
          treesitter-context = {
            enable = true;
            settings = {
              line_numbers = true;
              max_lines = 3;
            };
          };
          lualine = {
            enable = true;
          };
          mini-icons = {
            enable = true;
            mockDevIcons = true;
          };
          friendly-snippets = {
            enable = true;
          };
          snacks = {
            enable = true;
            settings = {
              statuscolumn = {
                enabled = true;
              };
              dashboard = {
                enabled = true;
                sections = [
                  { section = "header"; }
                  {
                    section = "keys";
                    gap = 1;
                    padding = 1;
                  }
                ];
              };
              bigfile = {
                enabled = true;
              };
              quickfile = {
                enabled = true;
              };
              words = {
                enabled = true;
              };
              notifier = {
                enabled = true;
              };
              input = {
                enabled = true;
              };
              explorer = {
                enabled = true;
              };
              image = {
                enabled = true;
              };
              picker = {
                enabled = true;
                db = {
                  sqlite3_path = "${pkgs.sqlite.out}/lib/libsqlite3.so";
                };
              };
              scope = {
                enabled = true;
              };
              scroll = {
                enabled = true;
              };
              indent = {
                enabled = true;
                hl = "SnacksIndent";
              };
              scratch = {
                enabled = true;
              };
            };
          };
          typst-preview = {
            enable = true;
          };
          oil = {
            enable = true;
          };
        };
        diagnostic = {
          settings = {
            virtual_text = true;
            virtual_lines = {
              only_current_line = true;
            };
          };
        };
        colorschemes = {
          onedark = {
            enable = true;
          };
        };

      };
    };
  };
}
