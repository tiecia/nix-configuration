{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    bitwarden.enable = lib.mkEnableOption "Enable bitwarden";
  };

  config = mkIf config.bitwarden.enable {
    home.packages = with pkgs; [
      bitwarden
    ];
  };
}
