{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
  };

  config = {
    environment = {
      shellAliases = {
        edit = "code ~/nix-configuration";
        rebuild = "~/nix-configuration/nixos-rebuild.sh";

        sconf = "nano ~/nix-configuration/hosts/${config.environment.sessionVariables.CONFIGURATION_HOST}/configuration.nix";
        hconf = "nano ~/nix-configuration/hosts/${config.environment.sessionVariables.CONFIGURATION_HOST}/home.nix";
        nxrs = "sudo nixos-rebuild switch --flake ~/nix-configuration/#${config.environment.sessionVariables.CONFIGURATION_HOST}";
        nxrt = "sudo nixos-rebuild test --flake ~/nix-configuration/#${config.environment.sessionVariables.CONFIGURATION_HOST}";
      };
    };
  };
}
