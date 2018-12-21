set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
let g:vundle_default_git_proto = 'https'
call vundle#begin()

" Plugins to install
Plugin 'VundleVim/Vundle.vim'

" Syntax/filetype detection
Plugin 'saltstack/salt-vim'

" Helpful plugins
Plugin 'Lokaltog/vim-easymotion'
Plugin 'Lokaltog/vim-powerline'
Plugin 'jistr/vim-nerdtree-tabs'
Plugin 'mileszs/ack.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'sjl/gundo.vim'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-eunuch'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-endwise'
Plugin 'airblade/vim-gitgutter'
Plugin 'walm/jshint.vim'
Plugin 'davidhalter/jedi-vim'
Plugin 'ervandew/supertab'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'michaeljsmith/vim-indent-object'
Plugin 'flazz/vim-colorschemes'
Plugin 'kien/ctrlp.vim'

" My Plugin
Plugin 'johnnygaffey/vim-j5'

call vundle#end()

filetype plugin indent on

if filereadable(expand("~/.vim/bundle/vim-j5/vimrc.vim"))
    execute "source ~/.vim/bundle/vim-j5/vimrc.vim"
endif

set belloff=all
