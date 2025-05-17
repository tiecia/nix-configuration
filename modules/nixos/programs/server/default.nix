{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./home_assistant.nix
    ./music_assistant.nix
  ];
}
