with import <nixpkgs> { };
{
  allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "qq"
      "wechat"
      "rime-flypy"
    ];
}
