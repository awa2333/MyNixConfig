{
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [ ./searchEngine.nix ];
  programs = {
    firefox = {
      enable = true;
      languagePacks = [ "zh-CN" ];
      configPath = "${config.xdg.configHome}/mozilla/firefox";
      policies = {
        Preferences = {
          "browser.translations.automaticallyPopup" = false;
          "browser.tabs.closeWindowWithLastTab" = false;
          "browser.engagement.sidebar-button.has-used" = true;
          "browser.toolbarbuttons.introduced.sidebar-button" = true;
        };
        RequestedLocales = [ "zh-CN" ];
        AppAutoUpdate = false;
        BackgroundAppUpdate = false;
        DisableFirefoxStudies = true;
        DisableFirefoxAccounts = true;
        DisableFirefoxScreenshots = true;
        DisableForgetButton = true;
        DisableMasterPasswordCreation = true;
        DisableProfileImport = true;
        DisableProfileRefresh = true;
        DisableSetDesktopBackground = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableFormHistory = true;
        DisablePasswordReveal = true;
        BlockAboutConfig = false;
        BlockAboutProfiles = true;
        DisplayMenuBar = "never";
        DontCheckDefaultBrowser = true;
        OfferToSaveLogins = false;
        DownloadDirectory = "\${home}/Downloads";
        ExtensionSettings = {
          "*" = {
            installation_mode = "blocked";
          };
          "vimium-c@gdh1995.cn" = {
            installation_mode = "force_installed";
            updates_disabled = true;
          };
          "uBlock0@raymondhill.net" = {
            default_area = "menupanel";
            install_url = "https://f2.crxsoso.com/firefox/downloads/latest/ublock-origin/platform:2/ublock-origin.xpi";
            installation_mode = "force_installed";
            updates_disabled = true;
          };
        };
      };
      profiles = {
        default = {
          id = 0;
          isDefault = true;
          settings = {
            "sidebar.main.tools" = "";
            "sidebar.new-sidebar.has-used" = true;
            "sidebar.verticalTabs" = true;
            "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;
            "sidebar.visibility" = "hide-sidebar";
            "browser.toolbars.bookmarks.visibility" = "never";
          };
          extensions = {
            force = true;
            settings = {
              "vimium-c@gdh1995.cn" = {
                force = true;
                settings = {
                  keyMappings = lib.concatStringsSep "\n" [
                    "map J nextTab"
                    "map K previousTab"
                  ];
                  userDefinedCss = lib.fileContents ("${pkgs.callPackage ./vimium-c-catppuccin.nix { }}/latte.css");
                };
              };
              "uBlock0@raymondhill.net" = {
                force = true;
                settings =
                  let
                    searchAndBlockFn =
                      searchEngine: blockDomain: "${searchEngine}#?#li:has(cite:contains(${blockDomain}))";
                    bingBlockDomain =
                      BlockDomain:
                      builtins.map (searchEngine: searchAndBlockFn searchEngine BlockDomain) [
                        "cn.bing.com"
                        "www.bing.com"
                      ];
                  in
                  {
                    user-filters = builtins.concatStringsSep "\n" (
                      lib.lists.flatten [
                        (bingBlockDomain "csdn.net")
                        (bingBlockDomain "gitcode.com")
                        (bingBlockDomain "archlinux.org.cn")
                      ]
                    );
                  };
              };
            };
          };
          bookmarks = {
            force = true;
            settings =
              let
                bookmarksFn = name: url: { inherit name url; };
              in
              [
                (bookmarksFn "Home-manager Options" "https://nix-community.github.io/home-manager/options.xhtml")
                (bookmarksFn "NixOS Options" "https://nixos.org/manual/nixos/unstable/options.html")
                (bookmarksFn "Nixpkgs Manual" "https://nixos.org/manual/nixpkgs/unstable")
              ];
          };
          search = {
            force = true;
            default = "bing";
            privateDefault = "bing";
            engines = {
              oxfordlearnersdictionaries = {
                name = "oxford learners dictionaries";
                urls = [
                  {
                    template = "https://www.oxfordlearnersdictionaries.com/definition/english/{searchTerms}";
                  }
                ];
                icon = ./ODF.png;
                definedAliases = [
                  "@ox"
                  "@of"
                ];
              };
              bilibili = {
                name = "BiliBili";
                urls = [
                  {
                    template = "https://search.bilibili.com/all";
                    params = [
                      {
                        name = "keyword";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = ./bilibili.png;
                definedAliases = [
                  "@bl"
                  "@bili"
                ];
              };
              GitHub = {
                urls = [
                  {
                    template = "https://github.com/search";
                    params = [
                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = ./github-mark.svg;
                definedAliases = [ "@gh" ];
              };
              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "channel";
                        value = "unstable";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };
              "Nix Options" = {
                urls = [
                  {
                    template = "https://search.nixos.org/options";
                    params = [
                      {
                        name = "channel";
                        value = "unstable";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@no" ];
              };
              "NixOS Wiki" = {
                urls = [
                  {
                    template = "https://wiki.nixos.org/w/index.php";
                    params = [
                      {
                        name = "search";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@nw" ];
              };
              "Nix Functions" = {
                urls = [
                  {
                    template = "https://noogle.dev/q";
                    params = [
                      {
                        name = "term";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [
                  "@nf"
                ];
              };
              "NixOS Discourse" = {
                urls = [
                  {
                    template = "https://discourse.nixos.org/search";
                    params = [
                      {
                        name = "q";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [
                  "@nd"
                ];
              };
              "ArchLinux Wiki" = {
                urls = [
                  {
                    template = "https://wiki.archlinux.org/index.php";
                    params = [
                      {
                        name = "search";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = ./archlinux-icon-crystal-256.svg;
                definedAliases = [ "@aw" ];
              };
              "ArchLinuxCN Wiki" = {
                urls = [
                  {
                    template = "https://wiki.archlinuxcn.org/wzh/index.php";
                    params = [
                      {
                        name = "search";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = ./archlinux-icon-crystal-256.svg;
                definedAliases = [ "@acw" ];
              };
              baidu.metaData.hidden = true;
              google.metaData.hidden = true;
              perplexity.metaData.hidden = true;
              ddg.metaData.hidden = true;
              wikipedia-zh-CN.metaData.hidden = true;
            };
          };
        };
      };
    };
  };
}
