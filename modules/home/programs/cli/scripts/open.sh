if [ -z $@ ]; then
  echo "No file name provided"
else
  nvim $(find -iname $@)
fi
