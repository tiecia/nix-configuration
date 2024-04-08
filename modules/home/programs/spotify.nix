{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    spotify.theme = mkOption {
      type = types.attrs;
      default = null;
      description = "Use Spicetify theme";
    };
  };

  config = {
    home.packages = mkIf (config.spotify.theme == null) [pkgs.hello];
    # home.packages = mkIf (config.spotify.theme != null) {
    #   []
    # };
  };

  # mkOptions = {
  #   spotify.theme = {
  #     type = types.attrs;
  #     default = null;
  #     description = "Use Spicetify theme";
  #   };
  # };

  # home.packages = (lib.mkIf config.spotify.theme == null) {
  #   [ pkgs.hello ]
  # };

  # home.packages = with pkgs; [
  #   spotify
  # ];
}
