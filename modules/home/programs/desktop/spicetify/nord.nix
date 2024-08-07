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
      text = "D8DEE9";
      subtext = "E5E9F0";
      nav-active-text = "D8DEE9";
      main = "2E3440";
      sidebar = "2E3440";
      player = "2E3440";
      card = "2E3440";
      shadow = "1d2128";
      main-secondary = "434c5e";
      button = "5E81AC";
      button-secondary = "D8DEE9";
      button-active = "81A1C1";
      button-disabled = "434C5E";
      nav-active = "4c566a";
      play-button = "5E81AC";
      tab-active = "3b4252";
      notification = "3b4252";
      notification-error = "3b4252";
      playback-bar = "DEDEDE";
      misc = "FFFFFF";
    };
  };
in
  config
