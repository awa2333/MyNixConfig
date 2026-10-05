{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.go-musicfox;
  settingsFormat = pkgs.formats.toml { };
in
{
  options.programs.go-musicfox = {
    enable = lib.mkEnableOption "musicfox";
    package = lib.mkPackageOption pkgs "go-musicfox" { };
    settings = lib.mkOption {
      inherit (settingsFormat) type;
      default = { };
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
    xdg.configFile."go-musicfox/config.toml" = lib.mkIf (cfg.settings != { }) {
      source = settingsFormat.generate "musicfox-config.toml" cfg.settings;
    };
  };
}
