{
  lib,
  ...
}:
{
  programs = {
    emacs = {
      enable = false;
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
