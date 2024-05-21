if [ -z $@ ]; then
  echo "No file name provided"
else
  vi $(find -iname $@)
fi
