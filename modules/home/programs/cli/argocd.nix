{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    argocd.enable = mkEnableOption "Enable argocd";
  };

  config = mkIf config.argocd.enable {
    home.packages = with pkgs; [
      argocd
    ];
  };
}
