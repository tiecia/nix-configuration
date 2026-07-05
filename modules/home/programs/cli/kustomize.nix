{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    kustomize.enable = mkEnableOption "Enable kustomize";
  };

  config = mkIf config.kustomize.enable {
    home.packages = with pkgs; [
      kustomize
    ];
  };
}
