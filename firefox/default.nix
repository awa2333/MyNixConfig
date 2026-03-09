{
  pkgs,
  ...
}:
{
  programs = {
    firefox = {
      enable = true;
      languagePacks = [ "zh-CN" ];
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
        ExtensionSettings =
          let
            moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
          in
          {
            "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
              install_url = moz "vimium-ff";
              installation_mode = "force_installed";
              updates_disabled = true;
            };
            "uBlock0@raymondhill.net" = {
              default_area = "menupanel";
              install_url = "https://f2.crxsoso.com/firefox/downloads/latest/ublock-origin/platform:2/ublock-origin.xpi";
              updates_disabled = true;
              installation_mode = "force_installed";
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
              "uBlock0@raymondhill.net" = {
                force = true;
                settings =
                  let
                    blk = short: "cn.bing.com#?#li:has(cite:contains(${short}))";
                  in
                  {
                    user-filters = builtins.concatStringsSep "\n" [
                      (blk "csdn.net")
                      (blk "gitcode.com")
                      (blk "archlinux.org.cn")
                    ];
                  };
              };
            };
          };
          bookmarks = {
            force = true;
            settings = [
              {
                name = "Home-manager Options";
                url = "https://nix-community.github.io/home-manager/options.xhtml";
              }
              {
                name = "NixOS Options";
                url = "https://nixos.org/manual/nixos/unstable/options.html";
              }
              {
                name = "Nixpkgs Manual";
                url = "https://nixos.org/manual/nixpkgs/unstable";
              }
            ];
          };
          search = {
            force = true;
            default = "bing";
            privateDefault = "bing";
            engines = {
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
