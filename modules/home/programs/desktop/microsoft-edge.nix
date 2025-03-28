{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    microsoft-edge.enable = lib.mkEnableOption "Enable microsoft-edge";
  };

  config = let
    microsoft-edge = pkgs.microsoft-edge;
  in
    mkIf config.microsoft-edge.enable {
      home.packages = [
        microsoft-edge
      ];

      xdg.desktopEntries = {
        microsoft-edge = {
          name = "Microsoft Edge";
          genericName = "Web Browser";
          exec = "${microsoft-edge}/bin/microsoft-edge";
          icon = "microsoft-edge";
          categories = ["Network" "WebBrowser"];
          startupNotify = true;
        };
      };
    };
}
