{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hyprwm.nix
    ./nvim.nix
    ./zsh.nix
    ./firefox.nix
    ./local
  ];
  home = {
    stateVersion = "25.11";
    preferXdgDirectories = true;
    keyboard = {
      layout = "us";
    };
    packages = with pkgs; [
      waybar
      unzip
      hyprlauncher
      nixfmt-rfc-style
      qq
      (wechat.overrideAttrs {
        src = fetchurl {
          url = "https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.AppImage";
          hash = "sha256-+r5Ebu40GVGG2m2lmCFQ/JkiDsN/u7XEtnLrB98602w=";
        };
      })
    ];
  };
  services = {
    home-manager = {
      autoExpire = {
        enable = true;
        frequency = "weekly";
        store = {
          cleanup = true;
        };
        timestamp = "-7 days";
      };
      autoUpgrade = {
        enable = true;
        frequency = "daily";
      };
    };
  };
  nixpkgs = {
    config = import ./src/nixpkgs.nix;
  };
  xdg = {
    enable = true;
    configFile = {
      "nixpkgs/config.nix".source = config.lib.file.mkOutOfStoreSymlink ./src/nixpkgs.nix;
    };
    dataFile = {
      "fcitx5/rime/default.custom.yaml".source =
        config.lib.file.mkOutOfStoreSymlink ./src/rime/default.custom.yaml;
      "fcitx5/rime/flypy.custom.yaml".source =
        config.lib.file.mkOutOfStoreSymlink ./src/rime/flypy.custom.yaml;
      "fcitx5/rime/flypy.dict.yaml".source =
        config.lib.file.mkOutOfStoreSymlink ./src/rime/flypy.dict.yaml;
    };
  };
  nix = {
    gc = {
      automatic = true;
    };
  };
  programs = {
    nix-your-shell = {
      enable = true;
    };
    yazi = {
      enable = true;
      enableZshIntegration = true;
      shellWrapperName = "yz";
      initLua = ./src/yazi_init.lua;
      plugins = with pkgs.yaziPlugins; {
        git = git;
        sudo = sudo;
        diff = diff;
        mount = mount;
        chmod = chmod;
        starship = starship;
        vcs-files = vcs-files;
        bookmarks = bookmarks;
      };
      settings = {
        mgr = {
          show_hidden = true;
        };
      };
    };
    rofi = {
      enable = true;
    };
    git = {
      enable = true;
      settings = {
        init = {
          defaultBrance = "main";
        };
      };
      lfs = {
        enable = true;
      };
    };
    ripgrep = {
      enable = true;
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      silent = true;
      nix-direnv = {
        enable = true;
      };
    };
    kitty = {
      enable = true;
      font.name = "Maple Mono Normal NF CN";
      themeFile = "OneDark-Pro";
      settings = {
        cursor_trail = 1;
        background_opacity = 0.7;
      };
    };
  };
  i18n = {
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-material-color
          (fcitx5-rime.override {
            rimeDataPkgs = [
              ((callPackage ./src/packages/rime-flypy.nix { }).overrideAttrs {
                postInstall = ''
                  cp ${rime-data}/share/rime-data/default.yaml $out/share/rime-data
                  cp ${rime-data}/share/rime-data/key_bindings.yaml $out/share/rime-data
                  cp ${rime-data}/share/rime-data/punctuation.yaml $out/share/rime-data
                  cp ${rime-data}/share/rime-data/symbols.yaml $out/share/rime-data
                '';
              })
            ];
          })
        ];
        settings = {
          inputMethod = {
            GroupOrder = {
              "0" = "Default";
            };
            "Groups/0" = {
              Name = "Default";
              "Default Layout" = "us";
              DefaultIM = "rime";
            };
            "Groups/0/Items/0" = {
              Name = "keyboard-us";
            };
            "Groups/0/Items/1" = {
              Name = "rime";
            };
          };
          addons = {
            classicui = {
              globalSection = {
                Theme = "Material-Color-sakuraPink";
              };
            };
          };
        };
      };
    };
  };
}
