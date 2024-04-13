# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  config,
  pkgs,
  pkgs-master,
  lib,
  spicetify-nix,
  ...
}: let
in {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default # Imports the home-manager module

    ../../modules/nixos/configuration
    ../../modules/nixos/desktop-environment

    # Programs
    ../../modules/nixos/programs/kde-connect.nix
    ../../modules/nixos/programs/docker.nix
    ../../modules/nixos/programs/steam.nix
    ../../modules/nixos/programs/prism-launcher.nix
    ../../modules/nixos/programs/syncthing.nix
    ../../modules/nixos/programs/wine.nix
  ];

  # hardware.opengl.enable = true;

  printing.enable = true;
  nvidia-graphics.enable = true;
  numlock-boot.enable = true;

  # Patch for xz vulnerability
  services.openssh.enable = lib.mkForce false;

  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true; # for solaar to be included

  # TODO: Move this to a home-manager configuration module
  home-manager = {
    extraSpecialArgs = {inherit inputs pkgs pkgs-master spicetify-nix;};
    users = {
      tiec = import ./home.nix;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  rebuild = {
    host = "desktop";
  };

  networking = {
    hostname = "TyDesktopNix";
  };

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
      # TODO: Move this to a home-manager configuration module. Then make a user module.
      home-manager
    ];
  };

  environment = {
    shellAliases = {
      # TODO: Make a module for these
      vpntvup = "sudo wg-quick up ~/TVWireguard.conf";
      vpntvdown = "sudo wg-quick down ~/TVWireguard.conf";

      # TODO: Move these to git.nix. Need to figure out why aliases are not working with homemanager.
      g = "git";
      gk = "gitkraken";
    };

    # TODO: Move these to vscode.nix. Need to figure out why environment variables are not working with homemanager.
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
