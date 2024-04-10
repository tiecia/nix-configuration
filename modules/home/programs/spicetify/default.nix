{
  pkgs,
  spicetify-nix,
  ...
}: {
  dark-blue = import ./dark-blue.nix {inherit pkgs spicetify-nix;};
  nord = import ./nord.nix {inherit pkgs spicetify-nix;};
}
