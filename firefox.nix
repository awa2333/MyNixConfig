{
  pkgs,
  lib,
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
        BlockAboutSupport = true;
        DisplayMenuBar = "never";
        DontCheckDefaultBrowser = true;
        OfferToSaveLogins = false;
        DownloadDirectory = "\${home}/Downloads";
        ExtensionSettings =
          let
            moz = short: "https://addons.mozilla.org/firefox/downloads/latest/${short}/latest.xpi";
          in
          {
            "*".installation_mode = "blocked";
            "vimium-c@gdh1995.cn" = {
              install_url = moz "vimium-c";
              installation_mode = "force_installed";
              updates_disbaled = true;
              private_browsing = true;
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
                url = "https://nixos.org/manual/nixos/stable/options.html";
              }
              {
                name = "Nixpkgs Manual";
                url = "https://nixos.org/manual/nixpkgs/stable";
              }
            ];
          };
          search = {
            force = true;
            default = "baidu";
            privateDefault = "baidu";
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
                icon = ./src/icons/bilibili.png;
                definedAliases = [
                  "@bl"
                  "@bili"
                ];
              };
              baidu = {
                name = "baidu";
                urls = [
                  {
                    template = "https://www.baidu.com/baidu?wd={searchTerms} -site:csdn.net -site:gitcode.com -site:archlinux.org.cn&rn=20";
                  }
                ];
                icon = ./src/icons/baidu-color.svg;
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
                icon = ./src/icons/github-mark.svg;
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
                  "@ng"
                  "@nf"
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
                icon = ./src/icons/archlinux-icon-crystal-256.svg;
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
                icon = ./src/icons/archlinux-icon-crystal-256.svg;
                definedAliases = [ "@acw" ];
              };
              bing.metaData.hidden = true;
              google.metaData.hidden = true;
              perplexity.metaData.hidden = true;
              ddg.metaData.hidden = true;
              wikipedia-zh-CN.metaData.hidden = true;
            };
          };
          extensions = {
            force = true;
            settings = {
              "vimium-c@gdh1995.cn" = {
                force = true;
                settings = {
                  "name" = "Vimium C";
                  "keyMappings" = lib.concatStringsSep "\n" [
                    "#!no-check"
                    "map J nextTab"
                    "map K previousTab"
                  ];
                  "searchEngines" = lib.concatStringsSep "\n" [
                    "np|nixpackages:https://search.nixos.org/packages?channel=unstable&query=%s"
                    "no|nixoptions:https://search.nixos.org/options?channel=unstable&query=%s"
                    "nw|nixoswiki:https://wiki.nixos.org/w/index.php?search=%s"
                    "ng|nf|noogle|nixfunctions:https://noogle.dev/q?term=%s"
                    "aw|archlinuxwiki:https://wiki.archlinux.org/index.php?search=%s"
                    "acw|archlinuxcnwiki:https://wiki.archlinuxcn.org/wzh/index.php?search=%s"
                    "ya|yd|yandex: https://yandex.com/search/?text=%s Yandex"
                    "bili|bilibili|bz|Bili: https://search.bilibili.com/all?keyword=%s \\"
                    "  blank=https://www.bilibili.com/ 哔哩哔哩"
                    "gs|g.s|gscholar|g.x|gx|gxs: https://scholar.google.com/scholar?q=$s \\"
                    "  scholar.google.com re=/^(?:\\.[a-z]{2,4})?\\/scholar\\b.*?[#&?]q=([^#&]*)/i \\"
                    "  blank=https://scholar.google.com/ 谷歌学术"
                    "\\:i: vimium://sed/s/^//,lower\\ $S re= Lower case"
                    "v.p: vimium://parse\\ $S re= Redo Search"
                    "gh|github: https://github.com/search?q=$s \\"
                    "  blank=https://github.com/ GitHub 仓库"
                    "js\\:|Js: javascript:\\ $S; JavaScript"
                  ];
                  "vimSync" = false;
                  "ignoreCapsLock" = 2;
                };
              };
            };
          };
        };
      };
    };
  };
}
