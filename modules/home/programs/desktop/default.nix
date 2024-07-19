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
    ./firefox/firefox.nix
    ./kalc.nix
    ./libreoffice.nix
    ./msteams.nix
    ./onedrive/onedrive.nix
    ./solaar.nix
    ./spotify.nix
    ./vscode.nix
    ./wine.nix
    ./vlc.nix
    ./davinci-resolve.nix
    ./obs.nix
    ./zoom.nix
    ./arduino-ide.nix
    ./cheese.nix
    ./quickemu.nix
  ];

  firefox.enable = lib.mkDefault true;
  vscode.enable = lib.mkDefault true;
  kalc.enable = lib.mkDefault true;
  vlc.enable = lib.mkDefault true;
  cheese.enable = lib.mkDefault true;
  quickemu.enable = lib.mkDefault true;
}
