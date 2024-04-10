{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./git.nix
    ./wireguard.nix
    ./wget.nix
    ./tree.nix
  ];

  # Programs that are enabled by default when the home/programs/cli directory is imported
  git.enable = lib.mkDefault true;
  wget.enable = lib.mkDefault true;
  tree.enable = lib.mkDefault true;
}
