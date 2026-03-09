{ lib, pkgs }:
{
  allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "rime-flypy"
      "qq"
      "wechat"
    ];
}
