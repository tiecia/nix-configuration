# Edit this configuration file to define what should be installed onconfiguration
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  config,
  pkgs,
  pkgs-master,
  pkgs-stable,
  lib,
  ...
}: let
in {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default # Imports the home-manager module

    ../../modules/nixos/configuration
    ../../modules/nixos/desktop-environment
    ../../modules/nixos/programs/cli
    ../../modules/nixos/programs/desktop
  ];

  # TODO: Move this to a home-manager configuration module
  home-manager.users.tiec = import ./home.nix;
  rebuild.host = "desktop";
  networking.hostName = "TyDesktopNix";

  hyprland.enable = true;

  services.samba.enable = lib.mkForce true;

  steam = {
    enable = true;
    enableGamescope = true;
    gamescopeArgs = ["-w 1920 -h 1080 -W 2560 -H 1080 -f"];
  };

  specialisation = {
    plasma.configuration = {
      hyprland.enable = lib.mkForce false;
      plasma.enable = true;
      environment.sessionVariables = {
        SPECIALISATION = "plasma";
      };
    };

    gnome.configuration = {
      hyprland.enable = lib.mkForce false;
      gnome.enable = true;
      environment.sessionVariables = {
        SPECIALISATION = "gnome";
      };
    };
  };

  fileSystems = {
    "/mnt/steam" = {
      device = "/dev/disk/by-uuid/C492E1D992E1D04A";
      fsType = "ntfs";
      options = ["uid=1000"];
    };

    "/mnt/hdd" = {
      device = "/dev/disk/by-uuid/9606B41606B3F4F9";
      fsType = "ntfs";
      options = ["uid=1000"];
    };

    "/mnt/datassd" = {
      device = "/dev/disk/by-uuid/F45A101B5A0FD96E";
      fsType = "ntfs";
      options = ["uid=1000"];
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
