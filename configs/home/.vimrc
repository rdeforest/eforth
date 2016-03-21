" https://github.com/tpope/vim-pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

set smartindent
set autoindent
set expandtab

set shiftwidth=2
set softtabstop=2
set background=dark

set linebreak
set showbreak=\ 

set backspace=indent,eol,start

syntax on

set modeline

au BufNewFile,BufFilePre,BufRead *.md     set  filetype=markdown

au BufNewFile,BufFilePre,BufRead *.coffee setl shiftwidth=2 expandtab
" au BufNewFile,BufFilePre,BufRead *.coffee setl foldmethod=indent

set tw=78
