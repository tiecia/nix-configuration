# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  inputs,
  config,
  pkgs,
  pkgs-master,
  lib,
  nixos-hardware,
  ...
}: let
in {
  imports = [
    ./hardware-configuration.nix
    # inputs.home-manager.nixosModules.default # Imports the home-manager module

    ../../modules/nixos/configuration
    ../../modules/nixos/desktop-environment
    ../../modules/nixos/programs/cli
    ../../modules/nixos/programs/desktop
  ];

  # home-manager.users.tiec = import ./home.nix;

  rebuild.host = "sls";
  networking.hostName = lib.mkForce "TyLaptopStudioNix";

  laptop-configuration.enable = lib.mkForce true;
  surface.enable = lib.mkForce true;

  nvidia-graphics = {
    enable = lib.mkForce true;
    prime = "offload";
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:243:0:0";
  };

  # services.create_ap = {
  #   enable = true;
  #   settings = {
  #     INTERNET_IFACE = "lo";
  #     WIFI_IFACE = "wlp242s0";
  #     SSID = "devenv";
  #     PASSPHRASE = "devenv1234";
  #   };
  # };

  gnome.enable = true;

  specialisation = {
    hyprland.configuration = {
      gnome.enable = lib.mkForce false;
      hyprland.enable = true;
      environment.sessionVariables = {
        SPECIALISATION = "hyprland";
      };
    };

    plasma.configuration = {
      gnome.enable = lib.mkForce false;
      plasma.enable = true;
      environment.sessionVariables = {
        SPECIALISATION = "plasma";
      };
    };

    # gnome.configuration = {
    #   hyprland.enable = lib.mkForce false;
    #   gnome.enable = true;
    #   environment.sessionVariables = {
    #     SPECIALISATION = "gnome";
    #   };
    # };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
