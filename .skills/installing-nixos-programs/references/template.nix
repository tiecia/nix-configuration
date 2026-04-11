{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    PROGRAM_NAME.enable = mkEnableOption "Enable PROGRAM_NAME";
  };

  config = mkIf config.PROGRAM_NAME.enable {
    home.packages = with pkgs; [
      PACKAGE_NAME
    ];
  };
}
