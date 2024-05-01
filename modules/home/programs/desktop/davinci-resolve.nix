{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    davinci-resolve.enable = lib.mkEnableOption "Enable Davinci Resolve";
  };

  config = mkIf config.davinci-resolve.enable {
    home.packages = with pkgs; [
      davinci-resolve
    ];
  };
}
