{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    quickemu.enable = lib.mkEnableOption "Enable quickemu";
  };

  config = mkIf config.quickemu.enable {
    home.packages = with pkgs; [
      quickemu
    ];
  };
}
