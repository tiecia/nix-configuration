{
  config,
  pkgs,
  ...
}: {
  # mkOptions = {
  #   spotify.theme = {
  #     type = types.attrs;
  #     default = null;
  #     description = "Use Spicetify theme";
  #   };
  # };

  # lib.mkIf (config.theme == null) {
  #   home.packages = with pkgs; [
  #     spotify
  #   ];
  # };

  home.packages = with pkgs; [
    spotify
  ];
}
