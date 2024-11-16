{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  virtualisation.docker.enable = true;
}
