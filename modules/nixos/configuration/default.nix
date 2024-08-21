{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./bluetooth.nix
    ./bootloader.nix
    ./flakes.nix
    ./locale-en-us.nix
    ./networking.nix
    ./pipewire.nix
    ./rebuild/rebuild.nix
    ./numlock.nix
    ./nvidia-graphics.nix
    ./printing.nix

    ./desktop.nix # Configuration to enable for desktop systems
  ];

  bluetooth.enable = lib.mkDefault true;
  bootloader.enable = lib.mkDefault true;
  flakes.enable = lib.mkDefault true;
  locale-en-us.enable = lib.mkDefault true;
  networking.enable = lib.mkDefault true;
  pipewire.enable = lib.mkDefault true;
  rebuild.enable = lib.mkDefault true;

  desktop-configuration.enable = lib.mkDefault true; # Configuration to enable for desktop systems
}
