{
  lib,
  pkgs,
  ...
}:
{
  wayland = {
    windowManager = {
      hyprland = {
        enable = true;
        configType = "lua";
        settings = {
          monitor =
            let
              monitorFn = output: mode: position: scale: {
                output = output;
                mode = mode;
                position = position;
                scale = scale;
              };
            in
            [
              (monitorFn "eDP-1" "1920x1080@144" "0x0" (builtins.div 4.0 3.0))
              (monitorFn "eDP-2" "1920x1080@144" "0x0" (builtins.div 4.0 3.0))
            ];
          env =
            let
              envFn = key: value: {
                _args = [
                  key
                  value
                ];
              };
            in
            [
              (envFn "XCURSOR_SIZE" "24")
              (envFn "LIBVA_DRIVER_NAME" "nvidia")
              (envFn "__GLX_VENDOR_LIBRARY_NAME" "nvidia")
              (envFn "GDK_BACKEND" "wayland,x11,*")
              (envFn "QT_QPA_PLATFORM" "wayland;xcb")
              (envFn "SDL_VIDEODRIVER" "wayland")
              (envFn "CLUTTER_BACKEND" "wayland")
            ];
          config = {
            general = {
              border_size = 2;
              gaps_in = 2;
              gaps_out = 2;
              col = {
                active_border = {
                  colors = [
                    "rgba(33ccffee)"
                    "rgba(00ff99ee)"
                  ];
                  angle = 45;
                };
                inactive_border = "rgba(595959aa)";
              };
            };
            decoration = {
              rounding = 1;
              rounding_power = 10.0;
              active_opacity = 0.9;
              inactive_opacity = 0.8;
              blur = {
                size = 3;
              };
            };
            xwayland = {
              force_zero_scaling = true;
            };
            ecosystem = {
              no_update_news = true;
              no_donation_nag = true;
            };
          };
          bind =
            let
              switchWorkspace =
                let
                  switchWorkspaceFnGenerator = key: event: num: {
                    _args = [
                      "SUPER + ${key} ${builtins.toString num}"
                      (lib.generators.mkLuaInline "hl.dsp.${event}({workspace=${
                        if num == 0 then "10" else builtins.toString num
                      }})")
                    ];
                  };
                  switchWorkspaceFn = num: [
                    (switchWorkspaceFnGenerator "" "focus" num)
                    (switchWorkspaceFnGenerator "SHIFT + " "window.move" num)
                  ];
                in
                builtins.concatLists (builtins.map switchWorkspaceFn (lib.range 0 9));
              superKeyEvent = do: key: content: {
                _args = [
                  ("SUPER + " + key)
                  (lib.generators.mkLuaInline "hl.dsp.${do}(${content})")
                ];
              };
              superKeyExec = key: cmd: superKeyEvent "exec_cmd" key ''"${cmd}"'';
              superKeyFocus = key: d: superKeyEvent "focus" key ''{direction="${d}"}'';
            in
            [
              (superKeyExec "Y" "kitty")
              (superKeyExec "F" "firefox")
              (superKeyExec "SHIFT+S" "hyprshot -m region --clipboard-only")
              (superKeyExec "I" "hyprlauncher")
              (superKeyFocus "H" "left")
              (superKeyFocus "J" "down")
              (superKeyFocus "K" "up")
              (superKeyFocus "L" "right")
              (superKeyEvent "window.fullscreen" "SPACE" ''{mode="fullscreen"}'')
              (superKeyEvent "window.close" "P" "")
            ]
            ++ switchWorkspace;
          on =
            let
              wallpaper = "${pkgs.callPackage ./wallpaper.nix { }}/wallpaper.mp4";
            in
            {
              _args = [
                "hyprland.start"
                (lib.generators.mkLuaInline (
                  builtins.concatStringsSep "\n" [
                    "function()"
                    ''hl.exec_cmd("mpvpaper -vs -o \"no-audio loop\" eDP-1 ${wallpaper}")''
                    ''hl.exec_cmd("mpvpaper -vs -o \"no-audio loop\" eDP-2 ${wallpaper}")''
                    "end"
                  ]
                ))
              ];
            };
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
