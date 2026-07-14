{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    lima.enable = mkEnableOption "Enable lima. Ubuntu virtualization.";
  };

  config = mkIf config.lima.enable {
    home.packages = with pkgs; [
      lima
    ];
  };
}
