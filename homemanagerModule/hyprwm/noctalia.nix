{
  programs = {
    noctalia = {
      enable = true;
      systemd = {
        enable = true;
      };
      settings = {
        theme = {
          sync_color_scheme = false;
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
      };
    };
  };
}
