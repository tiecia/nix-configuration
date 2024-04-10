{pkgs, ...}: {
  imports = [
    ./git.nix
    ./wireguard.nix
    ./wget.nix
    ./tree.nix
  ];
}
