#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}"  )" >/dev/null && pwd )"

# Make sure that directory exists.
mkdir -p ~/.config/nvim
mkdir -p ~/.config/gtk-3.0
mkdir -p ~/.config/termite
mkdir -p ~/.xmonad
mkdir -p ~/.config/cmus
mkdir -p ~/.config/fusuma

# Links for dotfiles.
ln -fsT $SCRIPT_DIR/init.vim ~/.config/nvim/init.vim
ln -fsT $SCRIPT_DIR/gtk.css ~/.config/gtk-3.0/gtk.css
ln -fsT $SCRIPT_DIR/xmonad.hs ~/.xmonad/xmonad.hs
ln -fsT $SCRIPT_DIR/termite.config ~/.config/termite/config
ln -fsT $SCRIPT_DIR/cmus.rc ~/.config/cmus/rc
ln -fsT $SCRIPT_DIR/cmus.monokai ~/.config/cmus/monokai.theme
ln -fsT $SCRIPT_DIR/Xmodmap ~/.Xmodmap
ln -fsT $SCRIPT_DIR/xinitrc ~/.xinitrc
ln -fsT $SCRIPT_DIR/curlrc ~/.curlrc
ln -fsT $SCRIPT_DIR/fusuma.config.yml ~/.config/fusuma/config.yml
ln -fsT $SCRIPT_DIR/tmux.conf ~/.tmux.conf
ln -fsT $SCRIPT_DIR/screenrc ~/.screenrc

# Needs to be an executable by xinit.
chmod +x $SCRIPT_DIR/xinitrc
