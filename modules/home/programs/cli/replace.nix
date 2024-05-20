{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    replace.enable = mkEnableOption "Enable replace";
  };

  config = mkIf config.replace.enable {
    home.packages = with pkgs; [
      # Program is replace-literal
      replace
    ];
  };
}
