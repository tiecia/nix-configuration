{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    insomnia.enable = lib.mkEnableOption "Enable insomnia";
  };

  config = mkIf config.insomnia.enable {
    home.packages = with pkgs; [
      insomnia
    ];
  };
}
