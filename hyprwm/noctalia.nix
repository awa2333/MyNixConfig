{ pkgs, ... }: {
  programs = {
    noctalia = {
      enable = true;
      settings = {
        theme = {
          mode = "light";
          source = "builtin";
          builtin = "Catppuccin";
        };
        wallpaper = {
          enabled = false;
        };
        bar = {
          default = {
            start = [
              "launcher"
              "workspaces"
            ];
            auto_hide = true;
            show_on_workspace_switch = false;
            reserve_space = false;
            layer = "overlay";
            background_opacity = 0.6;
          };
        };
        location = {
          auto_locate = true;
        };
        plugins = {
          enabled = [
            "noctalia/mpvpaper"
          ];
          auto_update = "all";
        };
        plugin_settings = {
          "noctalia/mpvpaper" = {
            video_directory = "${pkgs.callPackage ./wallpaper.nix { }}";
            run_as_systemd = true;
          };
        };
      };
    };
  };
}
