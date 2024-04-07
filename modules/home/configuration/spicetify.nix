{
  pkgs,
  lib,
  spicetify-nix,
  ...
}: let
  spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
in {
  # allow spotify to be installed if you don't have unfree enabled already
  #   nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  #     "spotify"
  #   ];

  # import the flake's module for your system
  imports = [spicetify-nix.homeManagerModule];

  # configure spicetify :)
  programs.spicetify = {
    enable = true;

    theme = spicePkgs.themes.Sleek;
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
      button-active = "4a99e9";
      button-disabled = "21282f";
      nav-active = "37b778";
      play-button = "37b778";
      tab-active = "0a1527";
      notification = "051024";
      notification-error = "051024";
      playback-bar = "37b778";
      misc = "FFFFFF";
    };

    # customColorScheme = {
    #   text = "ffffff";
    #   # subtext = "F0F0F0";
    #   # sidebar-text = "e0def4";
    #   # main = "191724";
    #   # sidebar = "2a2837";
    #   # player = "191724";
    #   # card = "191724";
    #   # shadow = "1f1d2e";
    #   # selected-row = "797979";
    #   button = "ff0000";
    #   button-active = "00ff00";
    #   # button-disabled = "555169";
    #   # tab-active = "ebbcba";
    #   # notification = "1db954";
    #   # notification-error = "eb6f92";
    #   # misc = "6e6a86";
    # };

    enabledExtensions = with spicePkgs.extensions; [
      shuffle # shuffle+ (special characters are sanitized out of ext names)
    ];
  };
}
