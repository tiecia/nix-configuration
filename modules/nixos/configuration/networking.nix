{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    networking.enable = mkEnableOption "Enable networking";
    networking.hostname = mkOption {
      type = types.str;
      default = "nixos";
      description = "The network hostname to use.";
    };
  };

  config = {
    # Enable networking
    networking.networkmanager.enable = config.networking.enable;

    # Set the hostname
    networking.hostName = config.networking.hostname;
  };
}
