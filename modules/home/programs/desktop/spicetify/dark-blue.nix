{
  pkgs,
  spicetify-nix,
  ...
}: let
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.system};
  config = {
    # https://github.com/spicetify/spicetify-themes/tree/master/Sleek
    theme = spicePkgs.themes.sleek;
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
  };
in
  config
