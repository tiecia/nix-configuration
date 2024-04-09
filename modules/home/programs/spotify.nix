{
  config,
  lib,
  pkgs,
  spicetify-nix,
  ...
}: let
  x = "test";
in
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

      programs.spicetify =
        mkIf (builtins.trace "Theme: ${builtins.toJSON config.spotify.theme}" config.spotify.theme != null) {
          enable = true;
        }
        // config.spotify.theme;
    };
  }
