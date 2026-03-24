{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    uv.enable = mkEnableOption "Enable uv. The Python package manager.";
  };

  config = mkIf config.uv.enable {
    home.packages = with pkgs; [
      uv
    ];
  };
}
