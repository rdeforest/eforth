set t_Co=256

" https://github.com/tpope/vim-pathogen
"runtime bundle/vim-pathogen/autoload/pathogen.vim
"execute pathogen#infect()

" https://github.com/kchmck/vim-coffee-script
filetype plugin indent on
"autocmd FileType litcoffee runtime ftplugin/coffee.vim

" me
syntax enable

set   softtabstop=2
set   shiftwidth=2
set   tabstop=2

set   expandtab
set   smartindent
set   autoindent
set   cindent

set   linebreak
let   &showbreak = ' '

set nohls
set nofoldenable
set nowrap

set   backspace=start,eol,indent
set   background=dark

set   laststatus=2

set   textwidth=78
set   encoding=utf-8

set   guifont=Menlo\ Regular:h20

" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-easy-align'

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

Plug 'editorconfig/editorconfig-vim'
Plug 'kchmck/vim-coffee-script'
Plug 'jwhitley/vim-literate-coffeescript'
Plug 'tpope/vim-markdown'
Plug 'rhysd/vim-crystal'
Plug 'dhruvasagar/vim-table-mode'

call plug#end()

let g:markdown_fenced_languages = [ 'html', 'python', 'bash=sh', 'st', 'coffee', 'javascript', 'java', 'c' ]
