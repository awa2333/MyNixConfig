{
  config,
  pkgs,
  ...
}:
{
  xdg = {
    dataFile = {
      "fcitx5/rime/default.custom.yaml" = {
        source = config.lib.file.mkOutOfStoreSymlink ./default.custom.yaml;
        force = true;
      };
      "fcitx5/rime/flypy.custom.yaml" = {
        source = config.lib.file.mkOutOfStoreSymlink ./flypy.custom.yaml;
        force = true;
      };
      "fcitx5/rime/flypy.dict.yaml" = {
        source = config.lib.file.mkOutOfStoreSymlink ./flypy.dict.yaml;
        force = true;
      };
    };
  };
  i18n = {
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-material-color
          (fcitx5-rime.override {
            rimeDataPkgs = with pkgs.nur.repos.awa2333; [
              rime-flypy
              rime-prelude
            ];
          })
        ];
        settings = {
          inputMethod = {
            GroupOrder = {
              "0" = "Default";
            };
            "Groups/0" = {
              Name = "Default";
              "Default Layout" = "us";
              DefaultIM = "rime";
            };
            "Groups/0/Items/0" = {
              Name = "keyboard-us";
            };
            "Groups/0/Items/1" = {
              Name = "rime";
            };
          };
          addons = {
            classicui = {
              globalSection = {
                Theme = "Material-Color-sakuraPink";
              };
            };
          };
        };
      };
    };
  };
}
