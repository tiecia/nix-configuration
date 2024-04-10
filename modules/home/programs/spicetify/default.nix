{
  pkgs,
  spicetify-nix,
  ...
}: {
  dark-blue = import ./dark-blue.nix {inherit pkgs spicetify-nix;};
}
