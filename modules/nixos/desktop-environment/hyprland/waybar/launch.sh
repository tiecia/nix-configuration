#!/bin/bash
#  ____  _             _    __        __          _                 
# / ___|| |_ __ _ _ __| |_  \ \      / /_ _ _   _| |__   __ _ _ __  
# \___ \| __/ _` | '__| __|  \ \ /\ / / _` | | | | '_ \ / _` | '__| 
#  ___) | || (_| | |  | |_    \ V  V / (_| | |_| | |_) | (_| | |    
# |____/ \__\__,_|_|   \__|    \_/\_/ \__,_|\__, |_.__/ \__,_|_|    
#                                           |___/                   
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

waybar_config_root="$HOME/nix-configuration/modules/nixos/desktop-environment/hyprland/waybar"

# Check if waybar-disabled file exists
if [ -f $HOME/.cache/waybar-disabled ] ;then 
    # killall waybar
    pkill waybar
    exit 1 
fi

# ----------------------------------------------------- 
# Quit all running waybar instances
# ----------------------------------------------------- 
# killall waybar
pkill waybar
sleep 0.2

# ----------------------------------------------------- 
# Default theme: /THEMEFOLDER;/VARIATION
# ----------------------------------------------------- 
themestyle="/ml4w;/ml4w/light"

# ----------------------------------------------------- 
# Get current theme information from .cache/.themestyle.sh
# ----------------------------------------------------- 
if [ -f ~/.cache/.themestyle.sh ]; then
    themestyle=$(cat ~/.cache/.themestyle.sh)
else
    touch ~/.cache/.themestyle.sh
    echo "$themestyle" > ~/.cache/.themestyle.sh
fi

IFS=';' read -ra arrThemes <<< "$themestyle"
echo "Theme: ${arrThemes[0]}"

if [ ! -f $waybar_config_root/themes${arrThemes[1]}/style.css ]; then
    themestyle="/ml4w;/ml4w/light"
fi

# ----------------------------------------------------- 
# Loading the configuration
# ----------------------------------------------------- 
config_file="config"
style_file="style.css"

# Standard files can be overwritten with an existing config-custom or style-custom.css
if [ -f $waybar_config_root/themes${arrThemes[0]}/config-custom ] ;then
    config_file="config-custom"
fi
if [ -f $waybar_config_root/themes${arrThemes[1]}/style-custom.css ] ;then
    style_file="style-custom.css"
fi

echo "Style Used:"
echo $waybar_config_root/themes${arrThemes[1]}/$style_file

echo "Config Used"
echo $waybar_config_root/themes${arrThemes[0]}/$config_file

waybar -c $waybar_config_root/themes${arrThemes[0]}/$config_file -s $waybar_config_root/themes${arrThemes[1]}/$style_file &
