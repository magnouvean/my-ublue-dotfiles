#!/usr/bin/env bash

set -e
cwd=$(dirname $0)

# System
just -f /etc/justfile update
just -f /etc/justfile setup-flatpaks
# just -f /etc/justfile setup-dev-vscodium
just -f /etc/justfile setup-dev-doom
# just -f /etc/justfile setup-dev-spacemacs
just -f /etc/justfile setup-gnome-settings
just -f /etc/justfile enable-services

# User
just -f $cwd/justfile install-dotfiles
just -f $cwd/justfile set-shell
just -f $cwd/justfile user-gnome-settings
