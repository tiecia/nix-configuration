{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (inputs) spicetify-nix;
  themes = import ./spicetify {inherit pkgs spicetify-nix;};
in
  with lib; {
    imports = [spicetify-nix.homeManagerModules.default];

    options = {
      # Enable option
      spotify.enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable Spotify";
      };

      # Theme option
      spotify.theme = mkOption {
        type = types.anything;
        default = null;
        description = "Use Spicetify theme";
      };
    };

    config = mkIf config.spotify.enable {
      # If no theme is specified install default spotify package.
      home.packages = mkIf (config.spotify.theme == null) [pkgs.spotify];

      # If a theme is specified use spicetify and apply the theme.
      programs.spicetify = mkMerge [
        {enable = true;}
        (mkIf (config.spotify.theme == "dark-blue") themes.dark-blue)
        (mkIf (config.spotify.theme == "nord") themes.nord)
      ];
    };
  }
