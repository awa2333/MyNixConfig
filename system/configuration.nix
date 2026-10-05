{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./secrets
  ];
  boot = {
    consoleLogLevel = 3;
    initrd = {
      verbose = false;
    };
    kernelParams = [
      "quiet"
      "splash"
      "rd.udev.log_level=3"
      "rd.systemd.show_status=auto"
    ];
    plymouth = {
      enable = true;
    };
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
    networkmanager = {
      enable = true;
    };
    proxy = {
      allProxy = "http://127.0.0.1:7890";
    };
    nftables = {
      enable = true;
    };
    firewall = {
      enable = true;
      allowedTCPPorts = [
        80
        443
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
      powerOnBoot = true;
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
    mihomo = {
      enable = true;
      configFile = ./secrets/mihomo.yaml;
      webui = pkgs.metacubexd;
      tunMode = true;
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
              Background = "${./secrets/sddm-background.png}";
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
    users = {
      luke = {
        ignoreShellProgramCheck = true;
        shell = pkgs.zsh;
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
        ]; # Enable ‘sudo’ for the user.
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
    ];
  };
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [ "@wheel" ];
      auto-optimise-store = true;
    };
  };
  security = {
    rtkit = {
      enable = true;
    };
  };
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     tree
  #   ];
  # };

  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  #system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?
}
