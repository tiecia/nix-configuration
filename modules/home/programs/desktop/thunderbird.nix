{
  config,
  lib,
  pkgs,
  pkgs-stable,
  inputs,
  ...
}:
with lib; {
  options = {
    thunderbird.enable = lib.mkEnableOption "Enable thunderbird";
  };

  config = mkIf config.thunderbird.enable {
    home.packages = [
      pkgs-stable.thunderbird
    ];
  };
}
