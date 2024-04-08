{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    spotify.theme = mkOption {
      type = types.anything;
      default = null;
      description = "Use Spicetify theme";
    };
  };

  config = {
    home.packages = mkIf (config.spotify.theme == null) [pkgs.spotify];

    programs.spicetify =
      mkIf (config.spotify.theme != null) {
        enable = true;
      }
      // config.spotify.theme;
  };
}
