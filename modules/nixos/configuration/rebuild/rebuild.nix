{
  config,
  lib,
  pkgs,
  ...
}: let
  compare = pkgs.writeShellScriptBin "compare" ''
    # No arguments compares the most recent two generations.
    # Two arguments compare the specified generations.

    if [ $# == 0 ]; then
        current=$(readlink /nix/var/nix/profiles/system | grep -o "[0-9]*")
        prev=$(($current-1))
        nvd diff /nix/var/nix/profiles/system-{$prev,$current}-link
        exit 0
    fi


    if [ $# -lt 2 ]; then
      echo 1>&2 "$0: not enough arguments"
      exit 2
    elif [ $# -gt 2 ]; then
      echo 1>&2 "$0: too many arguments"
      exit 2
    fi

    nvd diff /nix/var/nix/profiles/system-{$1,$2}-link
  '';
in
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

          # compare = "bash ~/nix-configuration/modules/nixos/configuration/rebuild/compare.sh";
          compare = "bash ${compare}/bin/compare";

          ns = "nix-shell";
          try = "nix-shell -p";

          conf = "nvim ~/nix-configuration/hosts/${host}/configuration.nix";
          home = "nvim ~/nix-configuration/hosts/${host}/home.nix";
          nxrs = "sudo nixos-rebuild switch --flake ~/nix-configuration/#${host}";
          nxrt = "sudo nixos-rebuild test --flake ~/nix-configuration/#${host}";
        };

        sessionVariables = {
          CONFIGURATION_HOST = host;
        };
      };
    };
  }
