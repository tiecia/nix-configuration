{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    notion.enable = lib.mkEnableOption "Enable notion";
  };

  config = mkIf config.notion.enable {
    home.packages = with pkgs; [
      notion-app-enhanced
    ];
  };
}
