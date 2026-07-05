{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    kubectl.enable = mkEnableOption "Enable kubectl";
  };

  config = mkIf config.kubectl.enable {
    home.packages = with pkgs; [
      kubectl
    ];

    programs.bash = {
      shellAliases = {
        k = "kubectl";
      };
    };
  };
}
