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
    # ./libreoffice.eix
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
    ./inkscape.nix
    ./gimp.nix
    ./wpsoffice.nix
    ./figma.nix
    ./winapps.nix
    ./dotnet.nix
    ./arduino-ide.nix
    ./onlyoffice.nix
    ./alacritty.nix
  ];

  firefox.enable = lib.mkDefault true;
  vscode.enable = lib.mkDefault true;
  kalc.enable = lib.mkDefault true;
  vlc.enable = lib.mkDefault true;
  cheese.enable = lib.mkDefault true;
  quickemu.enable = lib.mkDefault true;
  gimp.enable = lib.mkDefault true;
  inkscape.enable = lib.mkDefault true;
  wpsoffice.enable = lib.mkDefault true;
  onlyoffice.enable = lib.mkDefault true;
  figma.enable = lib.mkDefault true;
  winapps.enable = lib.mkDefault true;
  dotnet.enable = lib.mkDefault true;
  arduino-ide.enable = lib.mkDefault true;
  alacritty.enable = lib.mkDefault true;
  # davinci-resolve.enable = lib.mkDefault true;
}
