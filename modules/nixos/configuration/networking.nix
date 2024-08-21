{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  networking = {
    # hostname = lib.mkDefault "nixos";
    firewall = {
      enable = true;
      allowedTCPPorts = [8080 3000];
    };
  };

  networking.networkmanager.enable = lib.mkDefault true;

  networking.hostName = lib.mkDefault "nixos";

  # options = {
  #   networking.enable = mkEnableOption "Enable networking";
  #   networking.hostname = mkOption {
  #     type = types.str;
  #     default = "nixos";
  #     description = "The network hostname to use.";
  #   };
  # };
  #
  # config = {
  #   # Enable networking
  #   networking.networkmanager.enable = config.networking.enable;
  #
  #   # Set the hostname
  #   networking.hostName = config.networking.hostname;
  # };
}
