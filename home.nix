{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./musicfox.nix
    ./hyprwm
    ./fcitx5
    ./zshShell
    ./nvim
    ./firefox
    ./emacs
  ];
  home = {
    stateVersion = "26.05";
    username = "luke";
    homeDirectory = "/home/luke";
    preferXdgDirectories = true;
    shell = {
      enableZshIntegration = true;
    };
    keyboard = {
      layout = "us";
    };
    packages = with pkgs; [
      sops
      wpsoffice-cn
      wechat
      bilibili-tui
      telegram-desktop
      unzip
      hyprlauncher
      qq
    ];
    pointerCursor = {
      enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    sessionVariables = {
      NIXOS_OZONE_WL = 1;
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
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = "firefox.desktop";
        "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
        "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
      };
    };
  };
  programs = {
    home-manager = {
      enable = true;
    };
    go-musicfox = {
      enable = true;
      settings = {
        startup = {
          enable = true;
          progressOutBounce = true;
          loadingSeconds = 0.5;
          welcome = "musicfox";
          animation = "sequence";
          reduceMotion = false;
          signIn = false;
          checkUpdate = false;
        };
        main = {
          altScreen = true;
          enableMouseEvent = true;
          debug = false;
          frameRate = 5;
          locale = "zh";
          notification = {
            enable = true;
            icon = "logo.png";
          };
          lyric = {
            show = true;
          };
        };
        reporter = {
          netease = {
            enable = false;
          };
          lastfm = {
            enable = false;
          };
        };
      };
    };
    element-desktop = {
      enable = true;
    };
    hstr = {
      enable = true;
    };
    nix-your-shell = {
      enable = true;
    };
    nh = {
      osFlake = /etc/nixos;
      homeFlake = "${config.xdg.configHome}/home-manager";
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
    git = {
      enable = true;
      settings = {
        init = {
          defaultBrance = "main";
        };
        user = {
          email = "62987171+awa2333@users.noreply.github.com";
          name = "awa2333";
        };
      };
      lfs = {
        enable = true;
      };
    };
    gh-dash = {
      enable = true;
    };
    gh = {
      enable = true;
      gitCredentialHelper = {
        enable = true;
      };
      settings = {
        git_protocol = "ssh";
      };
    };
    lazygit = {
      enable = true;
    };
    direnv = {
      enable = true;
      silent = true;
      nix-direnv = {
        enable = true;
      };
    };
    less = {
      enable = true;
      config = builtins.concatStringsSep "\n" [
        "#env"
        "LESSUTFCHARDEF=E0BA:p,E0BC:p,F015:p,F023:p,F313:p"
      ];
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
  sops = {
    age = {
      keyFile = "${config.home.homeDirectory}/.age-key.txt";
    };
    defaultSopsFile = ./secrets/secrets.yaml;
    secrets = {
      neteaseCookie = { };
    };
  };
}
