#!/usr/bin/env bash

set -e
cwd=$(dirname $0)

if [ "$1" = "" ]; then

    # System
    # just -f /etc/justfile update
    just -f /etc/justfile setup-flatpaks
    # just -f /etc/justfile setup-dev-vscodium
    just -f /etc/justfile setup-dev-doom
    just -f /etc/justfile setup-gnome-settings
    just -f /etc/justfile enable-services

    # User
    just -f $cwd/justfile install-dotfiles
    just -f $cwd/justfile set-shell
    just -f $cwd/justfile user-gnome-settings

elif [ "$1" = "extra" ]; then

    # Programming languages
    just -f $cwd/justfile setup-dev-python
    just -f $cwd/justfile setup-dev-julia
    just -f $cwd/justfile setup-dev-R
    just -f $cwd/justfile setup-dev-latex

else

    echo "Invalid argument: $1"

fi
