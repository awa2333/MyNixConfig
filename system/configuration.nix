{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix # Include the results of the hardware scan.
    ./local
  ];
  hardware = {
    graphics = {
      enable = true;
    };
  };
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
        default = "saved";
        theme = "${
          pkgs.nur.repos.awa2333.Elegant-grub2-themes.override {
            themeConfig = {
              theme = "wave";
              type = "blur";
              color = "light";
              logo = "system";
            };
          }
        }/grub/themes/Elegant-grub2-themes";
        extraInstallCommands = ''
          ${pkgs.coreutils}/bin/cat << EOF >> /boot/grub/grub.cfg
          menuentry "UEFI Firmware Settings" {
            fwsetup
          }
          EOF
        '';
      };
    };
    plymouth = {
      enable = true;
    };
  };
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    gc = {
      automatic = true;
      dates = "monthly";
    };
  };
  networking = {
    hostName = "NixOS"; # Define your hostname.
    networkmanager = {
      enable = true;
    };
  };
  time = {
    timeZone = "Asia/Shanghai";
  };
  i18n = {
    defaultLocale = "en_US.UTF-8";
  };
  fonts = {
    packages = with pkgs; [
      wqy_zenhei
      wqy_microhei
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      noto-fonts
      noto-fonts-cjk-sans
      maple-mono.Normal-NF-CN
      nerd-fonts.jetbrains-mono
    ];
  };
  users = {
    defaultUserShell = pkgs.zsh;
    users = {
      root = {
        shell = lib.mkForce pkgs.zsh;
      };
    };
  };
  services = {
    displayManager = {
      defaultSession = "hyprland";
      sddm = {
        enable = true;
        theme = "${pkgs.nur.repos.awa2333.sddm-eucalyptus-drop}/share/sddm/themes/eucalyptus-drop";
        wayland = {
          enable = true;
        };
        settings = {
          Wayland = {
            CompositorCommand = "start-hyprland -- -c ${./src/hyprland.conf}";
          };
        };
      };
    };
  };
  programs = {
    nano = {
      enable = false;
    };
    bash = {
      enable = false;
    };
    hyprland = {
      enable = true;
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions = {
        enable = true;
      };
    };
  };
  environment = {
    systemPackages = with pkgs; [
      libsForQt5.qt5.qtgraphicaleffects
      sddm-astronaut
      sddm-sugar-dark
      sddm-chili-theme
      catppuccin-sddm
      elegant-sddm
      where-is-my-sddm-theme
      catppuccin-sddm-corners
    ];
    pathsToLink = [
      "/share/zsh"
    ];
  };
  nix = {
    settings = {
      substituters = [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://nix-community.cachix.org"
        "https://devenv.cachix.org"
        "https://cache.nixos-cuda.org"
        "https://yazi.cachix.org"
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
        "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };
}
