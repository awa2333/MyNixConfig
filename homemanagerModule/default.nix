{
  config,
  pkgs,
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
    ./bilibili-tui.nix
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
      kanban
      sops
      wpsoffice-cn
      telegram-desktop
      unzip
      qq
      wechat
    ];
    pointerCursor = {
      enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    sessionVariables = {
      NIXOS_OZONE_WL = 1;
      KANBAN_FILE = "${config.home.homeDirectory}/.boards.json";
    };
    backupFileExtension = "bak";
  };
  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [
          "JetBrainsMono Nerd Font"
          "Maple Mono Normal NF CN"
        ];
      };
    };
  };
  xdg = {
    enable = true;
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
      flake = "${config.home.homeDirectory}/.nixconfiguration";
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
          defaultBranch = "main";
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
    nix-index = {
      enable = true;
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
      settings = {
        cursor_trail = 1;
      };
    };
    devenv = {
      enable = true;
      settings = {
        shell = {
          prompt_prefix = false;
        };
      };
    };
    bilibili-tui = {
      enable = true;
      settings = {
        theme = "one-dark";
        auto_play = false;
        video_quality = "best";
        danmaku = {
          enabled = false;
        };
      };
    };
    obs-studio = {
      enable = true;
    };
  };
  stylix = {
    targets = {
      firefox = {
        profileNames = [ "default" ];
      };
      neovim = {
        enable = false;
      };
      kitty = {
        variant256Colors = true;
        colors = {
          override = config.stylix.base16.mkSchemeAttrs "${pkgs.base16-schemes}/share/themes/onedark.yaml";
        };
        opacity = {
          override = {
            terminal = 0.7;
          };
        };
      };
      fcitx5 = {
        enable = false;
      };
    };
  };
}
