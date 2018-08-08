#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" >/dev/null && pwd )"
mkdir -p ~/.config/nvim
mkdir -p ~/.config/gtk-3.0
mkdir -p ~/.config/termite
mkdir -p ~/.xmonad

ln -fsT $SCRIPT_DIR/init.vim ~/.config/nvim/init.vim
ln -fsT $SCRIPT_DIR/gtk.css ~/.config/gtk-3.0/gtk.css
ln -fsT $SCRIPT_DIR/xmonad.hs ~/.xmonad/xmonad.hs
ln -fsT $SCRIPT_DIR/termite.config ~/.config/termite/config
