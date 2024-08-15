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
    ./alias.nix
    ./vim.nix
    ./jq.nix
    ./unzip.nix
    ./replace.nix
    ./nvim.nix
    ./eza.nix
  ];

  # Programs that are enabled by default when the home/programs/cli directory is imported
  git.enable = lib.mkDefault true;
  wget.enable = lib.mkDefault true;
  tree.enable = lib.mkDefault true;
  alias.enable = lib.mkDefault true;
  nvim.enable = lib.mkDefault true;
  jq.enable = lib.mkDefault true;
  unzip.enable = lib.mkDefault true;
  replace.enable = lib.mkDefault true;
  eza.enable = lib.mkDefault true;
}
