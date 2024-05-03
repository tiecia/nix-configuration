{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    docker.enable = mkEnableOption "Enable docker";
  };

  config = mkIf config.docker.enable {
    virtualisation.docker.enable = true;
  };
}
