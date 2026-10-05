{
  pkgs,
  ...
}:
{
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
              (rime-flypy.overrideAttrs {
                postConfigure = ''
                  cp ${./src}/* . 
                '';
              })
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
        themes = {
          Material-Color-sakuraPink = {
            theme = builtins.concatStringsSep "\n" [
              "[InputPanel]"
              "HighlightCandidateColor=#000000"
            ];
          };
        };
      };
    };
  };
}
