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
    ./platformio.nix
    ./screen.nix
    ./direnv.nix
    ./tmux.nix
    ./devenv.nix
    ./mmv.nix
    ./nodejs.nix
    ./dotnet.nix
    ./lm_sensors.nix
    ./ncdu.nix
    ./bash.nix
    ./poppler.nix
    ./dig.nix
    ./traceroute.nix
    ./azure.nix
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
  platformio.enable = lib.mkDefault true;
  screen.enable = lib.mkDefault true;
  direnv.enable = lib.mkDefault true;
  tmux.enable = lib.mkDefault true;
  devenv.enable = lib.mkDefault true;
  mmv.enable = lib.mkDefault true;
  nodejs.enable = lib.mkDefault true;
  lm_sensors.enable = lib.mkDefault true;
  ncdu.enable = lib.mkDefault true;
  bash.enable = lib.mkDefault true;
  poppler-pdf-tools.enable = lib.mkDefault true;
  dig.enable = lib.mkDefault true;
  traceroute.enable = lib.mkDefault true;

  dotnet.enable = lib.mkDefault true;
  azure-tools.enable = lib.mkDefault true;
}
