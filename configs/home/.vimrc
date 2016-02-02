" https://github.com/tpope/vim-pathogen
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

au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

set tw=78
