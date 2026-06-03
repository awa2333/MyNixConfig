{ lib, pkgs }:
{
  allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "wpsoffice-cn"
      "rime-flypy"
      "qq"
      "wechat"
    ];
}
