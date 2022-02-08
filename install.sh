#!/bin/bash

##################################
# nvim
##################################
if [ -d $HOME/.config/nvim ] ; then
  eval $(rm -rf $HOME/.config/nvim)
fi

eval $(ln -sf $(pwd)/.config/nvim $HOME/.config/nvim)

# install vim-plug if not installed
if ! [ -f $HOME/.local/share/nvim/site/autoload/plug.vim ] ; then
  eval $(sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim')
fi
