" Neovim init stub. Use if/when switching to Neovim.
" Place (or symlink) at ~/.config/nvim/init.vim - bridges Neovim to use ~/.vimrc.
" This file should reside at ${USER}/.config/nvim/init.vim

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
