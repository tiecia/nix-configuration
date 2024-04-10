{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    wget.enable = mkEnableOption "Enable wget";
  };

  config = mkIf config.wget.enable {
    home.packages = with pkgs; [
      wget
    ];
  };
}
