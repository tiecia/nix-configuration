{pkgs, ...}: {
  imports = [
    ./betterbird.nix
    ./bitwarden.nix
    ./chrome.nix
    ./discord.nix
    ./filezilla.nix
    ./firefox.nix
    # ./kalc.nix
    ./libreoffice.nix
    ./msteams.nix
    ./onedrive.nix
    ./solaar.nix
    ./spotify.nix
    ./vscode.nix
    # ./wine.nix
  ];
}
