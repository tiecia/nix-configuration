{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    jq.enable = mkEnableOption "Enable jq";
  };

  config = mkIf config.jq.enable {
    home.packages = with pkgs; [
      jq
    ];
  };
}
