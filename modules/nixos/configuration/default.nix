{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./bootloader.nix
    ./flakes.nix
    ./locale-en-us.nix
    ./networking.nix
    ./rebuild/rebuild.nix
    ./numlock.nix
    ./dynamic-linking.nix
    ./home-manager.nix

    ./desktop.nix # Configuration to enable for desktop systems
  ];

  bootloader.enable = lib.mkDefault true;
  flakes.enable = lib.mkDefault true;
  locale-en-us.enable = lib.mkDefault true;
  networking.enable = lib.mkDefault true;
  rebuild.enable = lib.mkDefault true;
  dynamic-linking.enable = lib.mkDefault true;

  desktop-configuration.enable = lib.mkDefault true; # Configuration to enable for desktop systems
}
