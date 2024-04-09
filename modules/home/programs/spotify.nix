{
  config,
  lib,
  pkgs,
  spicetify-nix,
  ...
}:
with lib; {
  options = {
    spotify.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Spotify";
    };

    spotify.theme = mkOption {
      type = types.anything;
      default = null;
      description = "Use Spicetify theme";
    };
  };

  config = mkIf config.spotify.enable {
    home.packages = mkIf (builtins.trace "Theme: ${builtins.toJSON config.spotify.theme}" config.spotify.theme == null) [pkgs.spotify];

    # imports = mkIf (config.spotify.theme != null) [spicetify-nix.homeManagerModule];

    # x = builtins.trace "Theme: ${builtins.toJSON config.spotify.theme}" config.spotify.theme;

    # programs.spicetify = mkIf (config.spotify.theme != null) config.spotify.theme;
    programs.spicetify = mkIf (config.spotify.theme != null) (
      {
        enable = true;

        # https://github.com/spicetify/spicetify-themes/tree/master/Sleek
        theme = spicetify-nix.packages.${pkgs.system}.default.themes.Sleek;
        # colorScheme = "deep";
        colorScheme = "custom";
        customColorScheme = {
          text = "ffffff";
          subtext = "ffffff";
          nav-active-text = "ffffff";
          main = "020816";
          sidebar = "051024";
          player = "030b1e";
          card = "0a1527";
          shadow = "000000";
          main-secondary = "06142d";
          button = "1DB954";
          button-secondary = "ffffff";
          button-active = "1DB954";
          button-disabled = "21282f";
          nav-active = "37b778";
          play-button = "37b778";
          tab-active = "1DB954";
          notification = "051024";
          notification-error = "051024";
          playback-bar = "37b778";
          misc = "FFFFFF";
        };
      }
      #// config.spotify.theme
    );
  };
}
