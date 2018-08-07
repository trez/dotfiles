#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" >/dev/null && pwd )"
ln -fsT $SCRIPT_DIR/init.vim ~/.config/nvim/init.vim
ln -fsT $SCRIPT_DIR/gtk.css ~/.config/gtk-3.0/gtk.css
ln -fsT $SCRIPT_DIR/xmonad.hs ~/.xmonad/xmonad.hs
