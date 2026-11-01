{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];
  boot = {
    consoleLogLevel = 3;
    kernelParams = [
      "quiet"
      "splash"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=auto"
    ];
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        default = "saved";
        extraInstallCommands = ''
          ${pkgs.coreutils}/bin/cat << EOF >> /boot/grub/grub.cfg
          menuentry "UEFI Firmware Settings" {
            fwsetup
          }
          EOF
        '';
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
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/efi";

      };
    };
    kernelPackages = pkgs.linuxPackages_zen;
  };
  networking = {
    hostName = "nixos";
    nameservers = [
      "127.0.0.1"
    ];
    networkmanager = {
      enable = true;
      dns = "none";
    };
  };
  systemd = {
    services = {
      mihomo = {
        serviceConfig = {
          AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
          CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
        };
      };
    };
    tmpfiles = {
      rules = [
        "L+ /var/lib/mihomo/GeoSite.dat - - - - ${pkgs.v2ray-rules-dat}/share/v2ray/geosite.dat"
        "L+ /var/lib/mihomo/GeoIP.dat - - - - ${pkgs.v2ray-rules-dat}/share/v2ray/geoip.dat"
      ];
    };
  };
  time = {
    timeZone = "Asia/Shanghai";
  };
  nixpkgs = {
    config = {
      allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "nvidia-x11"
          "nvidia-settings"
          "rime-flypy"
          "wpsoffice-cn"
          "qq"
          "wechat"
        ];
    };
  };
  programs = {
    zsh = {
      enable = true;
    };
    hyprland = {
      enable = true;
    };
    nano = {
      enable = false;
    };
  };
  hardware = {
    bluetooth = {
      enable = true;
    };
    graphics = {
      enable = true;
    };
    nvidia = {
      open = true;
      modesetting = {
        enable = true;
      };
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        nvidiaBusId = "PCI:1@0:0:0";
        amdgpuBusId = "PCI:6@0:0:0";
      };
      powerManagement = {
        enable = true;
      };
    };
    keyboard = {
      qmk = {
        enable = true;
      };
    };
  };
  powerManagement = {
    enable = true;
  };
  services = {
    upower = {
      enable = true;
    };
    tuned = {
      enable = true;
    };
    mihomo = {
      enable = true;
      configFile = config.sops.secrets.mihomoConfig.path;
      webui = pkgs.metacubexd;
      tunMode = true;
      processesInfo = true;
    };
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse = {
        enable = true;
      };
    };
    asusd = {
      enable = true;
      asusdConfig = {
        source = ./asusd.ron;
      };
    };
    xserver = {
      enable = true;
      videoDrivers = [
        "nvidia"
        "amdgpu"
      ];
    };
    displayManager = {
      enable = true;
      defaultSession = "hyprland";
      sddm = {
        enable = true;
        extraPackages = with pkgs; [
          qt6.qt5compat
        ];
        theme = "${
          pkgs.nur.repos.awa2333.sddm-eucalyptus-drop.override {
            themeConfig = {
              HeaderText = "NixOS";
              AllowEmptyPassword = true;
              ForceRightToLeft = true;
              Background = "${pkgs.miscFiles}/sddm-background.png";
            };
          }
        }/share/sddm/themes/eucalyptus-drop";
        wayland = {
          enable = true;
          compositor = "kwin";
        };
      };
    };
  };
  users = {
    mutableUsers = false;
    users = {
      root = {
        isSystemUser = true;
        hashedPasswordFile = config.sops.secrets.rootPassword.path;
      };
      luke = {
        isNormalUser = true;
        hashedPasswordFile = config.sops.secrets.lukePassword.path;
        ignoreShellProgramCheck = true;
        shell = pkgs.zsh;
        extraGroups = [
          "wheel"
          "networkmanager"
        ];
      };
    };
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

      gyre-fonts
      source-han-serif
      tex-gyre-math.termes
    ];
  };
  nix = {
    # Optional runtime-only credentials; never put access-tokens in nix.settings/store.
    # See README: opt in with an encrypted sops secret after provisioning its key.
    extraOptions = ''
      !include /run/secrets/nix-access-tokens
    '';
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [ "@wheel" ];
      trusted-public-keys = [
        "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];
      trusted-substituters = [
        "https://cache.nixos-cuda.org"
        "https://devenv.cachix.org"
      ];
      substituters =
        let
          chineseSubstituters = [
            "https://mirrors.cernet.edu.cn/nix-channels/store"
            "https://mirrors.ustc.edu.cn/nix-channels/store"
            "https://mirrors.ha.edu.cn/nix-channels/store"
            "https://mirror.nju.edu.cn/nix-channels/store"
            "https://mirror.nyist.edu.cn/nix-channels/store"
            "https://mirror.sjtu.edu.cn/nix-channels/store"
          ];
          addPriority = url: "${url}?priority=10";
        in
        (builtins.map addPriority chineseSubstituters)
        ++ [
          "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        ];
    };
  };
  security = {
    rtkit = {
      enable = true;
    };
  };
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-storm.yaml";
    polarity = "dark";
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };
    };
    targets = {
      grub = {
        enable = false;
      };
    };
  };
  sops = {
    age = {
      keyFile = "${config.home-manager.users.luke.xdg.configHome}/sops/age/keys.txt";
    };
    defaultSopsFile = ./secrets.yaml;
    secrets = {
      neteaseCookie = {
        owner = config.users.users.luke.name;
      };
      lukePassword = {
        neededForUsers = true;
      };
      rootPassword = {
        neededForUsers = true;
      };
      mihomoConfig = {
        format = "binary";
        sopsFile = ./mihomo-secret.yaml;
        restartUnits = [ "mihomo.service" ];
      };
    };
  };
  system = {
    stateVersion = "26.05";
  };
}
