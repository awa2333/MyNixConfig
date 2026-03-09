{
  lib,
  ...
}:
{
  programs = {
    emacs = {
      enable = true;
      extraConfig = lib.fileContents ./init.el;
      extraPackages =
        epkgs: with epkgs; [
          nerd-icons
          projectile
          page-break-lines
          dashboard
          evil
        ];
    };
  };
  services = {
    emacs = {
      enable = true;
    };
  };
}
