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
      alejandra
      libnotify # Provides the notify-send used in my nixos-rebuild script
    ];
  };

  environment = {
    # For some reason doing this in home-manger is not working. Eventually theses should be moved to home-manager
    shellAliases = {
      # edit = "code ~/nix-configuration";
      # rebuild = "~/nix-configuration/nixos-rebuild.sh";

      # sconf = "nano ~/nix-configuration/hosts/desktop/configuration.nix";
      # hconf = "nano ~/nix-configuration/hosts/desktop/home.nix";
      # nxrs = "sudo nixos-rebuild switch --flake ~/nix-configuration/#desktop";
      # nxrt = "sudo nixos-rebuild test --flake ~/nix-configuration/#desktop";

      vpntvup = "sudo wg-quick up ~/TVWireguard.conf";
      vpntvdown = "sudo wg-quick down ~/TVWireguard.conf";

      g = "git";
    };

    sessionVariables = {
      EDITOR = "code";
      # CONFIGURATION_HOST = "desktop";
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
