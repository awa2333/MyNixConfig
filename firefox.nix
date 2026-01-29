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
            "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}" = {
              install_url = moz "styl-us";
              installation_mode = "force_installed";
              updates_disabled = true;
            };
            "FirefoxColor@mozilla.com" = {
              install_url = moz "firefox-color";
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
          };
          extensions = {
            force = true;
            settings = {
              "FirefoxColor@mozilla.com" = {
                force = true;
                settings = {
                  firstRunDone = true;
                  theme = {
                    colors =
                      let
                        a = r: g: b: {
                          inherit r g b;
                        };
                        r239 = a 239 241 245;
                        r76 = a 76 79 105;
                        r220 = a 220 224 232;
                        r230 = a 230 233 239;
                        r136 = a 136 57 239;
                        r156 = a 156 160 176;
                      in
                      {
                        toolbar = r239;
                        toolbar_text = r76;
                        frame = r220;
                        tab_background_text = r76;
                        toolbar_field = r230;
                        toolbar_field_text = r76;
                        tab_line = r136;
                        popup = r239;
                        popup_text = r76;
                        button_background_active = r156;
                        frame_inactive = r220;
                        icons_attention = r136;
                        icons = r136;
                        ntp_background = r220;
                        ntp_text = r76;
                        popup_border = r136;
                        popup_highlight_text = r76;
                        popup_highlight = r156;
                        sidebar_border = r136;
                        sidebar_highlight_text = r76;
                        sidebar_highlight = r136;
                        sidebar_text = r76;
                        sidebar = r239;
                        tab_background_separator = r136;
                        tab_loading = r136;
                        tab_selected = r239;
                        tab_text = r76;
                        toolbar_bottom_separator = r239;
                        toolbar_field_border_focus = r136;
                        toolbar_field_border = r239;
                        toolbar_field_focus = r239;
                        toolbar_field_highlight_text = r239;
                        toolbar_field_highlight = r136;
                        toolbar_field_separator = r136;
                        toolbar_vertical_separator = r136;
                      };
                    title = "Catppuccin latte mauve";
                    images = {
                      additional_backgrounds = [ "./bg-000.svg" ];
                      custom_backgrounds = [ ];
                    };
                  };
                  images = {
                  };
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
            default = "bd";
            privateDefault = "bd";
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
              bd = {
                name = "bd";
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
