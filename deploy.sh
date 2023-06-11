#!/usr/bin/env bash

set -e
cwd=$(dirname $0)

if [ "$1" = "" ]; then

    just -f $cwd/justfile system
    # just -f /usr/share/ublue-os/just/custom.just update
    just -f /usr/share/ublue-os/just/custom.just flatpaks
    # just -f /usr/share/ublue-os/just/custom.just dev-vscodium
    just -f /usr/share/ublue-os/just/custom.just dev-doom
    just -f /usr/share/ublue-os/just/custom.just services

    just -f $cwd/justfile dotfiles
    [ -f /usr/bin/gnome-shell ] && just -f $cwd/justfile gnome-settings
    [ -f /usr/bin/plasmashell ] && just -f $cwd/justfile kde-settings

elif [ "$1" = "extra" ]; then

    # Programming languages
    just -f $cwd/justfile dev-python
    just -f $cwd/justfile dev-julia
    just -f $cwd/justfile dev-R
    just -f $cwd/justfile dev-latex

else

    echo "Invalid argument: $1"

fi
