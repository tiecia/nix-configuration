# A web browser
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; {
  options = {
    zen.enable = lib.mkEnableOption "Enable zen";
  };

  config = mkIf config.zen.enable {
    home.packages = [
      inputs.zen-browser.packages.${pkgs.system}.default
    ];
  };
}
