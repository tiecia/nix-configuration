{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
}
