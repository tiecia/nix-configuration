{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    poppler-pdf-tools.enable = mkEnableOption "Enable Poppler PDF utilities";
  };

  config = mkIf config.poppler-pdf-tools.enable {
    home.packages = with pkgs; [
      poppler_utils
    ];
  };
}
