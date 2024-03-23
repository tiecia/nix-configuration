# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default # Imports the home-manager module

    # Programs
    ../../modules/nixos/programs/kde-connect.nix
    ../../modules/nixos/programs/docker.nix
    ../../modules/nixos/programs/steam.nix

    # Configurations
    ../../modules/nixos/configuration/bluetooth.nix
    ../../modules/nixos/configuration/nvidia-graphics.nix
    ../../modules/nixos/configuration/printing.nix
    ../../modules/nixos/configuration/pipewire.nix # Sound configuration
    ../../modules/nixos/configuration/flakes.nix
    ../../modules/nixos/configuration/locale-en-us.nix
    ../../modules/nixos/configuration/networking.nix
    ../../modules/nixos/configuration/bootloader.nix
    ../../modules/nixos/configuration/rebuild.nix

    # Desktop environment
    ../../modules/nixos/desktop-environment/kde-plasma.nix
  ];

  # TODO: Move this to a home-manager configuration module
  home-manager = {
    extraSpecialArgs = {inherit inputs pkgs;};
    users = {
      tiec = import ./home.nix;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  rebuild = {
    host = "desktop";
  };

  # TODO: Move this to networking.nix
  networking.hostName = "TyDesktopNix"; # Define your hostname.

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tiec = {
    isNormalUser = true;
    description = "tiec";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker" # Gives tiec account access to the docker socket
    ];
    packages = with pkgs; [
      home-manager
    ];
  };

  environment = {
    shellAliases = {
      vpntvup = "sudo wg-quick up ~/TVWireguard.conf";
      vpntvdown = "sudo wg-quick down ~/TVWireguard.conf";

      # g = "git";
    };

    sessionVariables = {
      EDITOR = "code";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
