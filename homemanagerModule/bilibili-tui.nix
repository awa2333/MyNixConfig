{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.bilibili-tui;
  settingsFormat = pkgs.formats.json { };
  defaultConfig = {
    theme = "silkcircuit-neon";
    keybindings = {
      quit = "q";
      confirm = "Enter";
      back = "Esc";
      refresh = "r";
      nav_up = "k";
      nav_down = "j";
      nav_left = "h";
      nav_right = "l";
      nav_next_page = "Tab";
      nav_prev_page = "BackTab";
      page_down = "PageDown";
      page_up = "PageUp";
      section_prev = "[";
      section_next = "]";
      tab_1 = "1";
      tab_2 = "2";
      tab_3 = "3";
      next_theme = "t";
      play = "p";
      open_settings = "s";
      search_focus = "/";
      comment = "c";
      toggle_replies = "r";
      up_prev = "[";
      up_next = "]";
    };
    danmaku = {
      enabled = true;
      display_area = 0.5;
      opacity = 1.0;
      font_scale = 1.0;
      duration = 7.0;
      stroke_width = 2.5;
      line_height = 1.6;
      massive_mode = false;
      font_family = "Noto Sans CJK SC";
    };
    auto_play = true;
    video_quality = "best";
  };
  configDir =
    if pkgs.stdenv.hostPlatform.isDarwin && !config.xdg.enable then
      "Library/Application Support"
    else
      config.xdg.configHome;
in
{
  options.programs.bilibili-tui = {
    enable = lib.mkEnableOption "bilibili-tui";
    package = lib.mkPackageOption pkgs "bilibili-tui" { };
    settings = lib.mkOption {
      inherit (settingsFormat) type;
      default = { };
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf (!builtins.isNull cfg.package) [ cfg.package ];
    home.file."${configDir}/bilibili-tui/config.json" = lib.mkIf (cfg.settings != { }) {
      source = settingsFormat.generate "bilibili-tui-config.json" (defaultConfig // cfg.settings);
    };
  };
}
