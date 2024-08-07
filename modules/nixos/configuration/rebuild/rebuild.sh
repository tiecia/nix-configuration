#!/usr/bin/env bash
# A rebuild script that commits on a successful build
set -e


# CONFIGURATION_HOST="desktop" # This is usually set from configuration.nix
# EDITOR="code" # This is usually set from configuration.nix

# cd to your config dir
pushd ~/nix-configuration

update=0
impure=0
dry=0
test=0
verbose=0
nopush=0

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
    fi
done

# Autoformat your nix files
alejandra . &>/dev/null \ || ( alejandra . ; echo "formatting failed!" && exit 1)

# Shows your changes
git diff -U0 *.nix

sudo git add -A

echo "NixOS rebuilding with host configuration \"$CONFIGURATION_HOST\""

nix flake lock --update-input custom-nvim

options=""
# Rebuild, output simplified errors, log trackebacks
if [ $impure == 1 ]; then
	sudo nixos-rebuild switch --impure --flake ./#$CONFIGURATION_HOST 
else
    if [ $dry == 1 ]; then
        options+="--dry "
    fi

    if [ $verbose == 1 ]; then
        options+="--verbose "
    fi
    
    if [ $update == 1 ]; then
        options+="--update "
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

# Get current generation metadata
current=$(nixos-rebuild list-generations --flake ./#$CONFIGURATION_HOST | grep current)

# Commit all changes witih the generation metadata
if [ $dry == 0 ]; then
    sudo git commit -am "$CONFIGURATION_HOST $current"
fi

# if [ $nopush == 0 ]; then
  # git push
# fi

sudo chown -R $USER ./

# Back to where you were
popd

echo "NixOS Rebuild OK!"

# Notify all OK!
# notify-send -e "NixOS Rebuild OK!" --icon=software-update-available
