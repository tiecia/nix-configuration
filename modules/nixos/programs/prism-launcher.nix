{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    prism-launcher.enable = mkEnableOption "Enable prism-launcher";
  };

  config = mkIf config.prism-launcher.enable {
    environment.systemPackages = with pkgs; [
      prismlauncher
    ];
  };
}
