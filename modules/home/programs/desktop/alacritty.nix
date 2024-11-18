{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    alacritty.enable = lib.mkEnableOption "Enable alacritty";
  };

  config = mkIf config.alacritty.enable {
    home.packages = with pkgs; [
      alacritty
    ];
  };
}
