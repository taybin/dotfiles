" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin(stdpath('data') . '/plugged')

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'morhetz/gruvbox'
Plug 'neomake/neomake'
Plug 'scrooloose/nerdTree'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-surround'

" Initialize plugin system
call plug#end()

let g:airline_theme='base16_gruvbox_dark_hard'

" set indentation to be 4 and use spaces
set tabstop     =4
set softtabstop =4
set shiftwidth  =4
set expandtab

" Full config: when writing or reading a buffer, and on changes in insert and
" normal mode (after 1s; no delay when writing).
call neomake#configure#automake('nrwi', 500)

" Change Deoplete menu to use Ctrl-j And Ctrl-k for up and down
inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"

nmap <C-n> :NERDTreeToggle<CR>
