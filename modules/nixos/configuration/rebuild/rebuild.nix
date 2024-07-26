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

  config = let
    inherit (config.rebuild) host;
  in {
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
        nixclean = "nh clean all --keep 10";
        cleannix = "nh clean all --keep 10";
        search = "nh search";

        compare = "bash ~/nix-configuration/modules/nixos/configuration/rebuild/compare.sh";

        ns = "nix-shell";
        try = "nix-shell -p";

        conf = "nano ~/nix-configuration/hosts/${host}/configuration.nix";
        home = "nano ~/nix-configuration/hosts/${host}/home.nix";
        nxrs = "sudo nixos-rebuild switch --flake ~/nix-configuration/#${host}";
        nxrt = "sudo nixos-rebuild test --flake ~/nix-configuration/#${host}";
      };

      sessionVariables = {
        CONFIGURATION_HOST = host;
      };
    };
  };
}
