if [ ! -z (pgrep waybar) ]; then
  pkill rofi
else
  rofi $@
fi
