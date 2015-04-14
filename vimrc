set nocompatible
filetype off

" vundle configuration "
if has("win32")
    let g:vim_home_path = "~/vimfiles"
else
    let g:vim_home_path = "~/.vim"
endif

execute "set rtp+=" . g:vim_home_path . "/bundle/vundle/"
let g:vundle_default_git_proto = 'https'
call vundle#rc(g:vim_home_path. "/bundle")

" Bundles to install
Bundle 'gmarik/vundle'

" Syntax/filetype detection
Bundle 'saltstack/salt-vim'

" Helpful plugins
Bundle 'Lokaltog/vim-easymotion'
Bundle 'Lokaltog/vim-powerline'
Bundle 'jistr/vim-nerdtree-tabs'
Bundle 'mileszs/ack.vim'
Bundle 'scrooloose/nerdcommenter'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'
Bundle 'sjl/gundo.vim'
Bundle 'tpope/vim-abolish'
Bundle 'tpope/vim-eunuch'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-endwise'
Bundle 'airblade/vim-gitgutter'
Bundle 'walm/jshint.vim'
Bundle 'davidhalter/jedi-vim'
Bundle 'ervandew/supertab'
Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'michaeljsmith/vim-indent-object'
Bundle 'flazz/vim-colorschemes'
Bundle 'kien/ctrlp.vim'

" My Bundle
Bundle 'johnnygaffey/vim-j5'

filetype plugin indent on

if filereadable(expand(g:vim_home_path . "/bundle/vim-j5/vimrc.vim"))
    execute "source " . g:vim_home_path . "/bundle/vim-j5/vimrc.vim"
endif
