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
        nh
        nvd
      ];

      shellAliases = {
        edit = "code ~/nix-configuration";
        rebuild = "~/nix-configuration/modules/nixos/configuration/rebuild/rebuild.sh";
        rb = "~/nix-configuration/modules/nixos/configuration/rebuild/rebuild.sh";
        listgens = "nix profile history --profile /nix/var/nix/profiles/system"; # https://nixos.org/manual/nix/stable/package-management/garbage-collection
        nixclean = "nh clean all --keep-since 4d";
        search = "nh search";

        compare = "~/nix-configuration/modules/nixos/configuration/rebuild/compare.sh";

        ns = "nix-shell";
        try = "nix-shell -p";

        sconf = "nano ~/nix-configuration/hosts/${config.environment.sessionVariables.CONFIGURATION_HOST}/configuration.nix";
        hconf = "nano ~/nix-configuration/hosts/${config.environment.sessionVariables.CONFIGURATION_HOST}/home.nix";
        nxrs = "sudo nixos-rebuild switch --flake ~/nix-configuration/#${config.environment.sessionVariables.CONFIGURATION_HOST}";
        nxrt = "sudo nixos-rebuild test --flake ~/nix-configuration/#${config.environment.sessionVariables.CONFIGURATION_HOST}";
      };

      sessionVariables = {
        CONFIGURATION_HOST = config.rebuild.host;
      };
    };
  };
}
