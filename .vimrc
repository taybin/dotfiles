if has('nvim')
  let vimplugdir='~/.config/nvim/plugged'
  let vimautoloaddir='~/.config/nvim/autoload'
  " TODO: pip2 install neovim
  " TODO: pip3 install neovim
else
  let vimplugdir='~/.vim/plugged'
  let vimautoloaddir='~/.vim/autoload'
endif

if empty(glob(vimautoloaddir . '/plug.vim'))
  " TODO: else?
  if executable('curl')
    execute 'silent !curl -fLo ' . vimautoloaddir . '/plug.vim --create-dirs ' .
          \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
endif


" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin(vimplugdir)

" Neovim is sensible by default
if !has('nvim')
  Plug 'tpope/vim-sensible'
endif

Plug 'junegunn/vim-plug'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'neomake/neomake'
Plug 'scrooloose/nerdTree'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-surround'
Plug 'Yggdroot/indentLine'
" Automatic generation of CTags
Plug 'vim-scripts/vim-misc' | Plug 'xolox/vim-easytags'
" Automatic update of CTags
Plug 'craigemery/vim-autotag'
" Nice browser for CTags
Plug 'majutsushi/tagbar'
" Highlight trailing whitespace
Plug 'ntpeters/vim-better-whitespace'
" And gitgutter
Plug 'airblade/vim-gitgutter'
" Auto-close scopes
Plug 'Raimondi/delimitMate'
" python support
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
" EditorConfig
Plug 'editorconfig/editorconfig-vim'

Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

Plug 'ervandew/supertab'

Plug 'deoplete-plugins/deoplete-jedi'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" Initialize plugin system
call plug#end()


set hidden

let g:airline_theme='base16_gruvbox_dark_hard'

" set indentation to be 4 and use spaces
set tabstop     =4
set softtabstop =4
set shiftwidth  =4
set expandtab

" Full config: when writing or reading a buffer, and on changes in insert and
" normal mode (after 1s; no delay when writing).
if has('nvim')
   call neomake#configure#automake('nrwi', 500)
endif

let g:deoplete#enable_at_startup = 1
if !exists('g:deoplete#omni#input_patterns')
  let g:deoplete#omni#input_patterns = {}
endif
" let g:deoplete#disable_auto_complete = 1
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

let g:UltiSnipsExpandTrigger="<C-j>"
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
let g:SuperTabDefaultCompletionType = "<C-n>"

nmap <C-n> :NERDTreeToggle<CR>
nmap <C-b> :TagbarToggle<CR>

set tags=./tags,.vimtags,~/.vim/tags;
set conceallevel=1

colorscheme gruvbox

let use_truecolor=0
if exists('$TMUX')
  let s:tmux_version = split(split(system('tmux -V'))[-1], '\.')
  let s:tmux_version_major = s:tmux_version[0]
  let s:tmux_version_minor = s:tmux_version[1]
  if ((s:tmux_version_major >= 2) && (s:tmux_version_minor >= 2))
    let use_truecolor=1
  else
    let use_truecolor=0
  endif
endif
if use_truecolor
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

" omnifuncs
augroup omnifuncs
  autocmd!
  " autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  " autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  " autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  " autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup end

" close quickfix window on close
augroup my_neomake_qf
    autocmd!
    autocmd QuitPre * if &filetype !=# 'qf' | lclose | endif
augroup END
