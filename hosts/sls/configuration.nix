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
  nixos-hardware,
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
      plasma.enable = true;
      environment.sessionVariables = {
        SPECIALISATION = "plasma";
      };
    };
  };

  printing.enable = true;

  nvidia-graphics = {
    enable = true;
    prime = "offload";
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:243:0:0";
  };

  microsoft-surface.ipts.enable = true;
  microsoft-surface.surface-control.enable = true;

  environment.systemPackages = with pkgs; [
    # xorg.xf86inputsynaptics
  ];

  boot.kernelParams = [
    "nvidia-drm.modeset=1"

    # Recommended for by https://wiki.hyprland.org/Nvidia/ for nvidia-vaapi-driver
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1" # This parameter is causing suspend issues on laptop
  ];

  hardware.logitech.wireless.enable = true;
  hardware.logitech.wireless.enableGraphical = true; # for solaar to be included

  # Programs
  kde-connect.enable = true;
  docker.enable = true;
  steam.enable = true;
  prism-launcher.enable = true;
  syncthing.enable = true;
  wine.enable = true;

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
    host = "sls";
  };

  networking = {
    hostname = "TyLaptopStudioNix";
  };

  services = {
    upower.enable = true; # Needed for battery module in AGS
    logind.extraConfig = ''
      HandlePowerKey=suspend
      HandleLidSwitch=suspend
      HandleLidSwitchExternalPower=suspend
    '';
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
      # hello
    ];
  };

  environment = {
    shellAliases = {
      # TODO: Make a module for these
      vpntvup = "sudo wg-quick up ~/TVWireguard.conf";
      vpntvdown = "sudo wg-quick down ~/TVWireguard.conf";
    };

    # TODO: Move these to vscode.nix. Need to figure out why environment variables are not working with homemanager.
    sessionVariables = {
      EDITOR = "vi";
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
