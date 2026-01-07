{
  pkgs,
  lib,
  ...
}:
{
  programs = {
    firefox = {
      enable = true;
      languagePacks = lib.mkForce [ "zh-CN" ];
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
        BlockAboutProfiles = true;
        BlockAboutSupport = true;
        DownloadDirectory = "\${home}/Downloads";
        DisableTelemetry = true;
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
                  "keyMappings" = lib.concatStrings [
                    "#!no-check"
                    "\n"
                    "map J nextTab"
                    "\n"
                    "map K previousTab"
                  ];
                  "searchEngines" = lib.concatStrings [
                    "np|nixpackages:https://search.nixos.org/packages?channel=unstable&query=%s"
                    "\n"
                    "nw|nixoswiki:https://wiki.nixos.org/w/index.php?search=%s"
                    "\n"
                    "aw|archlinuxwiki:https://wiki.archlinux.org/index.php?search=%s"
                    "\n"
                    "acw|archlinuxcnwiki:https://wiki.archlinuxcn.org/wzh/index.php?search=%s"
                    "\n"
                    "ya|yd|yandex: https://yandex.com/search/?text=%s Yandex"
                    "\n"
                    "bili|bilibili|bz|Bili: https://search.bilibili.com/all?keyword=%s \\"
                    "\n"
                    "  blank=https://www.bilibili.com/ 哔哩哔哩"
                    "\n"
                    "gs|g.s|gscholar|g.x|gx|gxs: https://scholar.google.com/scholar?q=$s \\"
                    "\n"
                    "  scholar.google.com re=/^(?:\\.[a-z]{2,4})?\\/scholar\\b.*?[#&?]q=([^#&]*)/i \\"
                    "\n"
                    "  blank=https://scholar.google.com/ 谷歌学术"
                    "\n"
                    "\\:i: vimium://sed/s/^//,lower\\ $S re= Lower case"
                    "\n"
                    "v.p: vimium://parse\\ $S re= Redo Search"
                    "\n"
                    "gh|github: https://github.com/search?q=$s \\"
                    "\n"
                    "  blank=https://github.com/ GitHub 仓库"
                    "\n"
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
