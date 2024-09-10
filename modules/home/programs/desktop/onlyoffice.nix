{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    onlyoffice-bin.enable = lib.mkEnableOption "Enable onlyoffice-bin";
  };

  config = mkIf config.onlyoffice-bin.enable {
    home.packages = with pkgs; [
      onlyoffice-bin
    ];
  };
}
