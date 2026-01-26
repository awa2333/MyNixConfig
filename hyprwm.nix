{
  ...
}:
{
  wayland = {
    windowManager = {
      hyprland = {
        enable = true;
        settings = {
          ecosystem = {
            no_update_news = true;
          };
          xwayland = {
            force_zero_scaling = true;
          };
          monitor = [
            "eDP-2,1920x1080@144,0x0,1.333333"
            "eDP-1,1920x1080@144,0x0,1.333333"
          ];
          "$terminal" = "kitty";
          exec-once = [
            "fcitx5"
            "mpvpaper -vs -o \"no-audio loop\" eDP-2 ${./src/wallpaper.mp4}"
            "mpvpaper -vs -o \"no-audio loop\" eDP-1 ${./src/wallpaper.mp4}"
          ];
          env = [
            "XCURSOR_SIZE,24"
            "HYPRCURSOR_SIZE,24"
            "GDK_BACKEND,wayland,x11,*"
            "QT_QPA_PLATFORM,wayland;xcb"
            "QT_AUTO_SCREEN_SCALE_FACTOR,1"
            "XDG_CURRENT_DESKTOP,Hyprland"
            "XDG_SESSION_TYPE,wayland"
            "XDG_SESSION_DESKTOP,Hyprland"
            "GBM_BACKEND,nvidia-drm"
            "__GLX_VENDOR_LIBRARY_NAME,nvidia"
            "LIBVA_DRIVER_NAME,nvidia"
          ];
          general = {
            gaps_in = "2";
            gaps_out = "2";
            border_size = "2";
            resize_on_border = false;
            allow_tearing = false;
            layout = "dwindle";
            "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
            "col.inactive_border" = "rgba(595959aa)";
          };
          decoration = {
            rounding = "1";
            rounding_power = "10.0";
            active_opacity = "0.9";
            inactive_opacity = "0.8";
            fullscreen_opacity = "1.0";
            shadow = {
              enabled = true;
              range = "4";
              render_power = "3";
              color = "rgba(1a1a1aee)";
            };
            blur = {
              enabled = true;
              size = "3";
              passes = "1";
              vibrancy = "0.1696";
            };
          };
          animations = {
            enabled = "yes, please :)";
            bezier = [
              "easeOutQuint,0.23,1,0.32,1"
              "easeInOutCubic,0.65,0.05,0.36,1"
              "linear,0,0,1,1"
              "almostLinear,0.5,0.5,0.75,1"
              "quick,0.15,0,0.1,1"
            ];
          };
          "$mainMod" = "SUPER";
          bind = [
            "$mainMod shift,s,exec,hyprshot -m region --clipboard-only"
            "$mainMod,space,fullscreen"
            "$mainMod,Y,exec,$terminal"
            "$mainMod,P,killactive,"
            "$mainMod,F,exec,firefox"
            "$mainMod,I,exec,hyprlauncher"

            "$mainMod,h,movefocus,l"
            "$mainMod,l,movefocus,r"
            "$mainMod,k,movefocus,u"
            "$mainMod,j,movefocus,d"

            "$mainMod,1,workspace,1"
            "$mainMod,2,workspace,2"
            "$mainMod,3,workspace,3"
            "$mainMod,4,workspace,4"
            "$mainMod,5,workspace,5"
            "$mainMod,6,workspace,6"
            "$mainMod,7,workspace,7"
            "$mainMod,8,workspace,8"
            "$mainMod,9,workspace,9"
            "$mainMod,0,workspace,10"

            "$mainMod SHIFT,1,movetoworkspace,1"
            "$mainMod SHIFT,2,movetoworkspace,2"
            "$mainMod SHIFT,3,movetoworkspace,3"
            "$mainMod SHIFT,4,movetoworkspace,4"
            "$mainMod SHIFT,5,movetoworkspace,5"
            "$mainMod SHIFT,6,movetoworkspace,6"
            "$mainMod SHIFT,7,movetoworkspace,7"
            "$mainMod SHIFT,8,movetoworkspace,8"
            "$mainMod SHIFT,9,movetoworkspace,9"
            "$mainMod SHIFT,0,movetoworkspace,10"
          ];
        };
        systemd = {
          enableXdgAutostart = true;
        };
      };
    };
  };
  services = {
    hyprpolkitagent = {
      enable = true;
    };
  };
  programs = {
    mpvpaper = {
      enable = true;
    };
    hyprshot = {
      enable = true;
      saveLocation = "$HOME/Pictures";
    };
  };
}
