{
  config,
  lib,
  pkgs,
  ...
}: {
  services.samba.enable = lib.mkDefault false;
}
