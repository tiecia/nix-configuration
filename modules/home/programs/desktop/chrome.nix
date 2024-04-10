{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    chrome.enable = lib.mkEnableOption "Enable chrome";
  };

  config = mkIf config.chrome.enable {
    home.packages = with pkgs; [
      google-chrome
    ];
  };
}
