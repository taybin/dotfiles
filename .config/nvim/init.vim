" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin(stdpath('data') . '/plugged')

Plug 'morhetz/gruvbox'
Plug 'neomake/neomake'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-surround'

" Initialize plugin system
call plug#end()

" Full config: when writing or reading a buffer, and on changes in insert and
" normal mode (after 1s; no delay when writing).
call neomake#configure#automake('nrwi', 500)
