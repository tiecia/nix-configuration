{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    eza.enable = mkEnableOption "Enable eza";
  };

  config = mkIf config.eza.enable {
    home.packages = with pkgs; [
      eza
    ];
  };
}
