{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./betterbird.nix
    ./bitwarden.nix
    ./chrome.nix
    ./discord.nix
    ./filezilla.nix
    ./firefox.nix
    ./kalc.nix
    ./libreoffice.nix
    ./msteams.nix
    ./onedrive.nix
    ./solaar.nix
    ./spotify.nix
    ./vscode.nix
    ./wine.nix
    ./vlc.nix
  ];

  firefox.enable = lib.mkDefault true;
  vscode.enable = lib.mkDefault true;
  kalc.enable = lib.mkDefault true;
  vlc.enable = lib.mkDefault true;
}
