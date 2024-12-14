# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL
{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.default # Imports the home-manager module
    ../../modules/nixos/configuration

    ../../modules/nixos/configuration/stylix.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  home-manager = {
    extraSpecialArgs = {inherit inputs pkgs;};
    users = {
      nixos = import ./home.nix;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  wsl.enable = true;
  wsl.defaultUser = "nixos";

  rebuild = {
    host = "wsl";
  };

  bluetooth.enable = lib.mkForce false;
  pipewire.enable = lib.mkForce false;
  bootloader.enable = lib.mkForce false;

  # nvidia-graphics.enable = lib.mkForce false;
  services.samba.enable = lib.mkForce false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nixos = {
    isNormalUser = true;
    description = "nixos";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker" # Gives tiec account access to the docker socket
    ];
    packages = with pkgs; [
      # TODO: Move this to a home-manager configuration module. Then make a user module.
      home-manager
    ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
