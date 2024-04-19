#!/usr/bin/env bash
#
# I believe there are a few ways to do this:
#
#    1. My current way, using a minimal /etc/nixos/configuration.nix that just imports my config from my home directory (see it in the gist)
#    2. Symlinking to your own configuration.nix in your home directory (I think I tried and abandoned this and links made relative paths weird)
#    3. My new favourite way: as @clot27 says, you can provide nixos-rebuild with a path to the config, allowing it to be entirely inside your dotfies, with zero bootstrapping of files required.
#       `nixos-rebuild switch -I nixos-config=path/to/configuration.nix`
#    4. If you uses a flake as your primary config, you can specify a path to `configuration.nix` in it and then `nixos-rebuild switch —flake` path/to/directory
# As I hope was clear from the video, I am new to nixos, and there may be other, better, options, in which case I'd love to know them! (I'll update the gist if so)

# A rebuild script that commits on a successful build
set -e


# CONFIGURATION_HOST="desktop" # This is usually set from configuration.nix
# EDITOR="code" # This is usually set from configuration.nix

# Edit your config
# $EDITOR ./hosts/$CONFIGURATION_HOST/configuration.nix


# cd to your config dir
pushd ~/nix-configuration

# If --nopush is present
nopush=0
force=0
update=0
impure=0

for arg in "$@"
do
    if [ "$arg" == "-n" ] || [ "$arg" == "--nopush" ]; then
        nopush=1
    elif [ "$arg" == "-f" ] || [ "$arg" == "--force" ]; then
        force=1
    elif [ "$arg" == "-u" ] || [ "$arg" == "--update" ]; then
        update=1
    elif [ "$arg" == "-i" ] || [ "$arg" == "--impure" ]; then
	impure=1
    fi
done

# Early return if no changes were detected (thanks @singiamtel!)
if git diff --quiet **/*.nix; then
    if [[ $force == 0 && update == 0 ]]; then
        echo "No changes detected, exiting."
        popd
        exit 0
    fi
fi

# Autoformat your nix files
alejandra . &>/dev/null \ || ( alejandra . ; echo "formatting failed!" && exit 1)

if [ $update == 1 ]; then
    konsole -e "bash -c 'tail -f ./nixos-switch.log; exec bash'" &
    nix flake update
fi

# Shows your changes
git diff -U0 *.nix

sudo git add -A

echo "NixOS rebuilding with host configuration \"$CONFIGURATION_HOST\""

# Rebuild, output simplified errors, log trackebacks
if [ $impure == 1 ]; then
	sudo nixos-rebuild switch --impure --flake ~/nix-configuration#$CONFIGURATION_HOST &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)
else
	sudo nixos-rebuild switch --flake ~/nix-configuration#$CONFIGURATION_HOST &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)
fi
# Get current generation metadata
current=$(nixos-rebuild list-generations --flake ~/nix-configuration#$CONFIGURATION_HOST | grep current)

# Commit all changes witih the generation metadata
sudo git commit -am "$CONFIGURATION_HOST $current"

# if [ $nopush == 0 ]; then
#     sudo git push
# fi

# Back to where you were
popd

echo "NixOS Rebuild OK!"

# Notify all OK!
notify-send -e "NixOS Rebuild OK!" --icon=software-update-available
