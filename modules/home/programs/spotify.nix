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
    home.packages = mkIf (config.spotify.theme == null) [pkgs.spotify];

    # imports = mkIf (config.spotify.theme != null) [spicetify-nix.homeManagerModule];

    # _ = builtins.trace "Theme: ${builtins.toJSON config.spotify.theme}" config.spotify.theme;

    programs.spicetify =
      mkIf (config.spotify.theme != null) {
        enable = true;
      }
      // builtins.trace "Theme: ${builtins.toJSON config.spotify.theme}" config.spotify.theme;
  };
}
