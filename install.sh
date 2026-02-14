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

##################################
# claude code
##################################
mkdir -p $HOME/.claude $HOME/.claude/skills $HOME/.claude/agents

# individual files — symlink
ln -sf $(pwd)/.claude/CLAUDE.md $HOME/.claude/CLAUDE.md
ln -sf $(pwd)/.claude/settings.json $HOME/.claude/settings.json

# directories — copy contents in (don't nuke plugin-installed items)
for dir in skills agents; do
  if [ -d "$(pwd)/.claude/$dir" ]; then
    find "$(pwd)/.claude/$dir" -mindepth 1 -maxdepth 1 -type d -exec cp -r {} "$HOME/.claude/$dir/" \;
  fi
done
