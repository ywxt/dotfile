#!/usr/bin/env bash

# 
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

sudo ln -sf "$SCRIPT_DIR/pacman/export-manual-list.hook" /etc/pacman.d/hooks/export-manual-list.hook

PKGS="${SCRIPT_DIR}/pacman/pkgs-$(uname -n).txt"

if [ ! -f "$PKGS" ]; then
    touch "$PKGS"
fi
sudo ln -sf "$SCRIPT_DIR/pacman/pkgs-$(uname -n).txt" /var/lib/pacman/pkgs-$(uname -n).txt
