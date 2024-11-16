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
    ./rebuild.nix
    ./numlock.nix
    ./dynamic-linking.nix
    ./home-manager.nix
    ./users.nix
    ./gpg.nix
    ./samba.nix

    ./desktop.nix # Configuration to enable for desktop systems
    ./laptop.nix
  ];

  bootloader.enable = lib.mkDefault true;
  flakes.enable = lib.mkDefault true;
  locale-en-us.enable = lib.mkDefault true;
  rebuild.enable = lib.mkDefault true;
  dynamic-linking.enable = lib.mkDefault true;
  docker.enable = lib.mkDefault true;
  numlock-boot.enable = lib.mkDefault true;

  desktop-configuration.enable = lib.mkDefault true; # Configuration to enable for desktop systems
  laptop-configuration.enable = lib.mkDefault false;

  nix = {
    extraOptions = ''
      trusted-users = root tiec
      extra-substituters = https://devenv.cachix.org
      extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
    '';
  };
}
