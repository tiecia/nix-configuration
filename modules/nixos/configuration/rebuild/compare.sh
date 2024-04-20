#!/usr/bin/env bash

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