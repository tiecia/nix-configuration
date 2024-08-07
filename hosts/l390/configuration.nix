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

    ../../modules/nixos/configuration
    ../../modules/nixos/desktop-environment
    ../../modules/nixos/programs
  ];

  plasma.enable = true;

  # Programs
  kde-connect.enable = true;
  docker.enable = true;
  steam.enable = true;
  syncthing.enable = true;
  wine.enable = true;
  wireguard.enable = true;

  # Configurations
  printing.enable = true;

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
    host = "l390";
  };

  networking = {
    hostname = "TyYogaL390";
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
      # TODO: Move these to git.nix. Need to figure out why aliases are not working with homemanager.
      g = "git";
      gk = "gitkraken";
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
