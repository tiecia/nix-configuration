{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    azure-tools.enable = mkEnableOption "Enable azure tools";
  };

  config = mkIf config.azure-tools.enable {
    home.packages = with pkgs; [
      azure-functions-core-tools
    ];
  };
}
