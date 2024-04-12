{
  config,
  pkgs,
  ...
}: {
  services.flatpak.enable = true;
  xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-gtk];
  xdg.portal.config.common.default = "gtk";
}
