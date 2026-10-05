{
  lib,
  ...
}:
{
  imports = [ ./noctalia.nix ];
  wayland = {
    windowManager = {
      hyprland = {
        enable = true;
        package = null;
        portalPackage = null;
        xwayland = {
          enable = true;
        };
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
              (monitorFn "HDMI-A-1" "2560x1440@144" "0x0" (builtins.div 4.0 3.0))
              (monitorFn "eDP-1" "1920x1080@144" "1920x0" (builtins.div 4.0 3.0))
              (monitorFn "eDP-2" "1920x1080@144" "1920x0" (builtins.div 4.0 3.0))
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
              (envFn "QT_IM_MODULES" "wayland;fcitx;ibus")
              (envFn "QT_IM_MODULE" "fcitx")
            ];
          config = {
            general = {
              layout = "scrolling";
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
          workspace_rule =
            let
              Fn = workspace: default: monitor: {
                inherit workspace monitor default;
              };
              builtinMonitos = builtins.map (Fn "3" true) [
                "eDP-1"
                "eDP-2"
              ];
            in
            builtinMonitos
            ++ (builtins.map (a: Fn (builtins.head a) (lib.last a) "HDMI-A-1") [
              [
                "1"
                true
              ]
              [
                "2"
                false
              ]
            ]);
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
              (superKeyFocus "H" "left")
              (superKeyFocus "J" "down")
              (superKeyFocus "K" "up")
              (superKeyFocus "L" "right")
              (superKeyEvent "window.fullscreen" "SPACE" ''{mode="fullscreen"}'')
              (superKeyEvent "window.close" "P" "")
              (superKeyExec "U" "noctalia msg panel-toggle launcher")
            ]
            ++ switchWorkspace;
          on =
            let
              autoStartFn =
                let
                  generatedLuaInline = cmd: ''hl.exec_cmd("${cmd}")'';
                in
                cmds: [
                  "hyprland.start"
                  (lib.generators.mkLuaInline (
                    builtins.concatStringsSep "\n" ([ "function()" ] ++ (lib.map generatedLuaInline cmds) ++ [ "end" ])
                  ))
                ];
            in
            {
              _args = autoStartFn [
                "noctalia"
              ];
            };
        };
      };
    };
  };
  xdg = {
    configFile = {
      "hypr/hyprland.lua" = {
        force = true;
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
