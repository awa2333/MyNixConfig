{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
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
        theme = "${
          (pkgs.callPackage ./src/packages/Elegant-grub2-themes/package.nix { })
        }/grub/themes/Elegant-wave-blur-left-light/";
        useOSProber = true;
        default = "saved";
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
        theme = "maya";
        wayland = {
          enable = true;
        };
        settings = {
          Wayland = {
            CompositorCommand = "Hyprland -c ${./src/hyprland.conf}";
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
      home-manager
      (callPackage ./src/packages/sddm-sugar-candy/package.nix { })
    ];
    pathsToLink = [
      "/share/zsh"
    ];
  };
  nix = {
    settings = {
      substituters = [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      ];
    };
  };
  system = {
    stateVersion = "25.11"; # Did you read the comment?
    autoUpgrade = {
      enable = true;
      dates = "daily";
    };
  };
}
