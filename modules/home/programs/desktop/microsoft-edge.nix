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
          comment = "Access the Internet";
          genericName = "Web Browser";
          exec = "${microsoft-edge}/bin/microsoft-edge";
          startupNotify = true;
          terminal = false;
          icon = "microsoft-edge";
          categories = ["Network" "WebBrowser"];
          mimeType = ["application/pdf" "application/rdf+xml" "application/rss+xml" "application/xhtml+xml" "application/xhtml_xml" "application/xml" "image/gif" "image/jpeg" "image/png" "image/webp" "text/html" "text/xml" "x-scheme-handler/http" "x-scheme-handler/https"];
        };
      };
    };
}
