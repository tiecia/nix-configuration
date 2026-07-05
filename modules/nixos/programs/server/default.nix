{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./home_assistant.nix
    ./music_assistant.nix
    ./snapcast.nix
    ./minecraft_server.nix
    ./portracker.nix
    ./glances.nix
    ./k3s.nix
    ./tailscale.nix
  ];
}
