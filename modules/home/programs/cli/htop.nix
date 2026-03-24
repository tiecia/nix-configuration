{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    htop.enable = mkEnableOption "Enable htop";
  };

  config = mkIf config.htop.enable {
    home.packages = with pkgs; [
      htop
    ];
  };
}
