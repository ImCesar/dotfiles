# Requires
NVIM 6.0

# Getting started

After cloning repo run the './install.sh' script

## Vim setup
Open Vim and run the following commands
- in vim run `PlugInstall`
- Install tsserver
  `npm i -g typescript-language-server`
  - see [list](https://github.com/DanielTolentino/nvim-lsp#configurations) for other languages 
- in vim run `:TSInstall javascript` to set up treesitter highlights
- in vim run `:TSInstall typescript` to set up treesitter highlights
- in vim run `:TSInstall vue` to set up treesitter highlights
- Install [RipGrep](https://github.com/BurntSushi/ripgrep#installation) to do project wide searches
- Install [LazyGit](https://github.com/jesseduffield/lazygit) to use floating git interface
- Install [NerdFont](https://www.nerdfonts.com/) and set terminal font to it to use icons
