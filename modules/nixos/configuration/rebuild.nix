{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options = {
    rebuild.enable = mkEnableOption "Enable the nixos-rebuild script";
    rebuild.host = mkOption {
      type = types.str;
      default = "default";
      description = "The name of the configuration host";
    };
  };

  config = {
    environment = {
      systemPackages = with pkgs; [
        alejandra # .nix formatter
        libnotify # Provides the notify-send used in my nixos-rebuild script
      ];
      shellAliases = {
        edit = "code ~/nix-configuration";
        rebuild = "~/nix-configuration/nixos-rebuild.sh";
        rb = "~/nix-configuration/nixos-rebuild.sh";
        listgens = "nix profile history --profile /nix/var/nix/profiles/system"; # https://nixos.org/manual/nix/stable/package-management/garbage-collection
        cleannix = "nix-collect-garbage -d";

        sconf = "nano ~/nix-configuration/hosts/${config.environment.sessionVariables.CONFIGURATION_HOST}/configuration.nix";
        hconf = "nano ~/nix-configuration/hosts/${config.environment.sessionVariables.CONFIGURATION_HOST}/home.nix";
        nxrs = "sudo nixos-rebuild switch --flake ~/nix-configuration/#${config.environment.sessionVariables.CONFIGURATION_HOST}";
        nxrt = "sudo nixos-rebuild test --flake ~/nix-configuration/#${config.environment.sessionVariables.CONFIGURATION_HOST}";
      };

      sessionVariables = {
        CONFIGURATION_HOST = config.rebuild.host;
      };
    };

    # TODO: Maybe add nixos-rebuild.sh here?
  };
}
