{
  config,
  lib,
  pkgs,
  spicetify-nix,
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
    home.packages = mkIf (builtins.trace "Theme: ${builtins.toJSON config.spotify.theme}" config.spotify.theme == null) [pkgs.spotify];

    # imports = mkIf (config.spotify.theme != null) [spicetify-nix.homeManagerModule];

    # x = builtins.trace "Theme: ${builtins.toJSON config.spotify.theme}" config.spotify.theme;

    # programs.spicetify = mkIf (config.spotify.theme != null) config.spotify.theme;
    programs.spicetify =
      mkIf (config.spotify.theme != null) {
        enable = true;
      }
      // config.spotify.theme;
  };
}
