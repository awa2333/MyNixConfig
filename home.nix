{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./hyprwm
    ./fcitx5
    ./zshShell
    ./nvim
    ./firefox
    ./emacs
  ];
  wayland.windowManager.sway.enable = true;
  home = {
    username = "luke";
    homeDirectory = "/home/luke";
    preferXdgDirectories = true;
    keyboard = {
      layout = "us";
    };
    packages = with pkgs; [
      wpsoffice-cn
      clash-verge-rev
      colmap
      unzip
      (wechat.overrideAttrs {
        src = fetchurl {
          url = "https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.AppImage";
          hash = "sha256-XxAvFnlljqurGPDgRr+DnuCKbdVvgXBPh02DLHY3Oz8=";
        };
      })
      hyprlauncher
      nixfmt
      qq
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
    config = import ./nixpkgs.nix { inherit lib pkgs; };
  };
  xdg = {
    enable = true;
    configFile = {
      "nixpkgs/config.nix" = {
        force = true;
        text = ''
          with import <nixpkgs> { };
          ${lib.fileContents ./nixpkgs.nix}
        '';
      };
    };
  };
  nix = {
    gc = {
      automatic = true;
    };
  };
  programs = {
    nix-index = {
      enable = true;
    };
    home-manager = {
      enable = true;
    };
    hstr = {
      enable = true;
    };
    nix-your-shell = {
      enable = true;
    };
    nh = {
      enable = true;
    };
    obs-studio = {
      enable = true;
    };
    yazi = {
      enable = true;
      shellWrapperName = "yz";
      initLua = ./yazi.lua;
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
      keymap = {
        mgr = {
          prepend_keymap = [
            {
              on = "M";
              run = "plugin mount";
            }
          ];
        };
      };
      settings = {
        mgr = {
          show_hidden = true;
          linemode = "size";
          show_symlink = true;
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
    gh = {
      enable = true;
    };
    lazygit = {
      enable = true;
    };
    ripgrep = {
      enable = true;
    };
    direnv = {
      enable = true;
      silent = true;
      nix-direnv = {
        enable = true;
      };
    };
    kitty = {
      enable = true;
      font = {
        name = "Maple Mono Normal NF CN";
      };
      themeFile = "OneDark-Pro";
      settings = {
        cursor_trail = 1;
        background_opacity = 0.7;
      };
    };
  };
}
