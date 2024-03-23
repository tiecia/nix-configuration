{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    networking.hostname = mkOption {
      type = types.str;
      default = "nixos";
      description = "The network hostname to use.";
    };
  };

  config = {
    # Enable networking
    networking.networkmanager.enable = true;

    # Set the hostname
    networking.hostName = config.networking.hostname;
  };
}
