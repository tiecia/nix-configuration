{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    helm.enable = mkEnableOption "Enable Kubernetes helm";
  };

  config = mkIf config.helm.enable {
    home.packages = with pkgs; [
      kubernetes-helm
    ];
  };
}
