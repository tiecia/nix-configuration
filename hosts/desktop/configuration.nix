# Edit this configuration file to define what should be installed onconfiguration
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  config,
  pkgs,
  pkgs-master,
  lib,
  ...
}: let
in {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default # Imports the home-manager module

    ../../modules/nixos/configuration
    ../../modules/nixos/desktop-environment
    ../../modules/nixos/programs
  ];

  hyprland.enable = true;

  specialisation = {
    plasma.configuration = {
      hyprland.enable = lib.mkForce false;
      plasma.enable = true;
      environment.sessionVariables = {
        SPECIALISATION = "plasma";
      };
    };

    # hyprland.configuration = {
    #   hyprland.enable = true;
    #   environment.sessionVariables = {
    #    SPECIALISATION = "hyprland";
    #   };
    # };
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged
    # programs here, NOT in environment.systemPackages
  ];

  programs.gnupg.agent.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [5000 1883];
  };

  printing.enable = true;
  # nvidia-graphics.enable = true;
  numlock-boot.enable = true;

  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true; # for solaar to be included

  # Programs
  kde-connect.enable = true;
  docker.enable = true;
  prism-launcher.enable = true;
  syncthing.enable = true;
  wine.enable = true;
  # wireguard.enable = true;

  steam = {
    enable = true;
    enableGamescope = true;
    gamescopeArgs = ["-w 1920 -h 1080 -W 2560 -H 1080 -f"];
  };

  services.samba.enable = true;

  # TODO: Move this to a home-manager configuration module
  home-manager = {
    extraSpecialArgs = {inherit inputs pkgs pkgs-master;};
    users = {
      tiec = import ./home.nix;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
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
      "dialout"
    ];
    packages = with pkgs; [
      # TODO: Move this to a home-manager configuration module. Then make a user module.
      home-manager
      linuxKernel.packages.linux_zen.xone
      # hello
    ];
  };

  environment = {
    # TODO: Move these to vscode.nix. Need to figure out why environment variables are not working with homemanager.
    sessionVariables = {
      EDITOR = "vi";
    };
  };

  fileSystems."/mnt/steam" = {
    device = "/dev/disk/by-uuid/C492E1D992E1D04A";
    fsType = "ntfs";
    options = ["uid=1000"];
  };

  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-uuid/9606B41606B3F4F9";
    fsType = "ntfs";
    options = ["uid=1000"];
  };

  fileSystems."/mnt/datassd" = {
    device = "/dev/disk/by-uuid/F45A101B5A0FD96E";
    fsType = "ntfs";
    options = ["uid=1000"];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
