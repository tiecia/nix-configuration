{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    wireshark.enable = lib.mkEnableOption "Enable wireshark";
  };

  config = mkIf config.wireshark.enable {
    home.packages = with pkgs; [
      wireshark
    ];
  };
}
