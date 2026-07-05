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

  rebuild = pkgs.writeShellScriptBin "rebuild" ''
    set -e

    # cd to your config dir
    pushd ~/nix-configuration

    fix_git_permissions() {
      if [ -d .git ]; then
        sudo chown -R "$USER:$(id -gn)" .git
      fi
    }

    update=0
    impure=0
    dry=0
    test=0
    verbose=0
    nopush=0
    target=0

    for arg in "$@"
    do
        if [ "$arg" == "-u" ] || [ "$arg" == "--update" ]; then
          update=1
        elif [ "$arg" == "-i" ] || [ "$arg" == "--impure" ]; then
          impure=1
        elif [ "$arg" == "-d" ] || [ "$arg" == "--dry" ]; then
          dry=1
        elif [ "$arg" == "-t" ] || [ "$arg" == "--test" ]; then
          test=1
        elif [ "$arg" == "-v" ] || [ "$arg" == "--verbose" ]; then
          verbose=1
        elif [ "$arg" == "-n" ] || [ "$arg" == "--nopush" ]; then
          nopush=1
        elif [ "$arg" == "-h" ] || [ "$arg" == "--home" ]; then
          target=1
        elif [ "$arg" == "-o" ] || [ "$arg" == "--os" ]; then
          target=2
        fi
    done

    # A sudo flake evaluation can leave root-owned objects in .git/objects.
    # Repair ownership up front so git add/commit keeps working.
    fix_git_permissions

    # Autoformat your nix files
    alejandra . &>/dev/null \ || ( alejandra . ; echo "formatting failed!" && exit 1)

    # Shows your changes
    git diff -U0 *.nix

    git add -A

    echo "NixOS rebuilding with host configuration \"$CONFIGURATION_HOST\""

    if [ $target == 0 ] || [ $target == 2 ]; then
      options=""
      # Build the flake as the user and let nh handle elevation only where needed.
      if [ $dry == 1 ]; then
        options+="--dry "
      fi

      if [ $verbose == 1 ]; then
        options+="--verbose "
      fi

      if [ $update == 1 ]; then
        options+="--update "
      fi

      if [ $impure == 1 ]; then
        options+="--impure "
      fi

      if [[ ! -z $SPECIALISATION ]]; then
        echo "Using specialisation \"$SPECIALISATION\""
        options+="-s $SPECIALISATION "
      fi

      if [ $test == 1 ]; then
        nh os test ./ -H $CONFIGURATION_HOST $options
      else
        nh os switch ./ -H $CONFIGURATION_HOST $options
      fi
    fi

    if [ $target == 0 ] || [ $target == 1 ]; then
      nh home switch ./ -c tiec@$CONFIGURATION_HOST
    fi

    # Get current generation metadata from the active profile symlink.
    current=$(readlink /nix/var/nix/profiles/system | grep -o "[0-9]*")
    hmVersion=$(home-manager generations | sort -r | head -n 1 | cut -d ' ' -f1-5)

    # Commit all changes with the generation metadata.
    if [ $dry == 0 ]; then
        if git diff --cached --quiet; then
          echo "No staged changes to commit"
        else
          git commit -m "$CONFIGURATION_HOST $current (HM: $hmVersion)"
        fi
    fi

    # if [ $nopush == 0 ]; then
      # git push
    # fi

    fix_git_permissions

    # Back to where you were
    popd

    echo "NixOS Rebuild OK!"
  '';

  rebuild-command = "bash ${rebuild}/bin/rebuild";
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
          rebuild = rebuild-command;
          rb = rebuild-command;
          listgens = "nix profile history --profile /nix/var/nix/profiles/system"; # https://nixos.org/manual/nix/stable/package-management/garbage-collection
          nixclean = "nh clean all --keep 3 --nogcroots";
          cleannix = "nh clean all --keep 3 --nogcroots";
          search = "nh search";

          compare = "bash ${compare}/bin/compare";

          ns = "nix-shell";
          try = "nix-shell -p";

          conf = "nvim ~/nix-configuration/hosts/${host}/configuration.nix";
          home = "nvim ~/nix-configuration/hosts/${host}/home.nix";
          nxrs = "nh os switch ~/nix-configuration -H ${host}";
          nxrt = "nh os test ~/nix-configuration -H ${host}";
        };

        sessionVariables = {
          CONFIGURATION_HOST = host;
        };
      };
    };
  }
