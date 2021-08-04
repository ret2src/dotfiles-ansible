" Automatically install vim-plug.
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins.
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes!

" A universal set of defaults that (hopefully) everyone can agree on.
Plug 'tpope/vim-sensible'

" Gruvbox color scheme.
Plug 'morhetz/gruvbox'

" Heuristically set buffer indentation options.
Plug 'tpope/vim-sleuth'

" Comment stuff out.
Plug 'tpope/vim-commentary'

" Insert or delete brackets, parens, quotes in pair.
Plug 'jiangmiao/auto-pairs'

" Wisely add "end" tags for different languages.
Plug 'tpope/vim-endwise'

" Quoting/parenthesizing made simple.
Plug 'tpope/vim-surround'

" Pairs of handy bracket mappings.
Plug 'tpope/vim-unimpaired'

" Enable repeating supported plugin maps with ".".
Plug 'tpope/vim-repeat'

" Use CTRL-A/CTRL-X to increment dates, times, and more.
Plug 'tpope/vim-speeddating'

" Vim motions on speed.
Plug 'easymotion/vim-easymotion'

" Lean & mean status/tabline for vim.
Plug 'vim-airline/vim-airline'

" Accelerate writing HTML and CSS.
Plug 'mattn/emmet-vim', { 'for': ['html', 'css'] }

" Initialize plugin system.
call plug#end()

" Use gruvbox colorscheme.
colorscheme gruvbox

" Fix colorscheme issues.
set termguicolors

" Configure 'emmet-vim'.

" Enable only for HTML and CSS.
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall

" Use spaces instead of tabs.
let g:user_emmet_settings = {
\  'html' : {
\    'indentation' : '  '
\  },
\  'css' : {
\    'indentation' : '  '
\  }
\}

" Configure 'vim-airline'.

" Show buffer numbers.
let g:airline#extensions#tabline#buffer_nr_show = 1

" Display buffers when there's only one tab open.
let g:airline#extensions#tabline#enabled = 1

" Configure 'vim-easymotion'.
let g:EasyMotion_do_mapping = 0 " Disable default mappings

" Jump to anywhere you want with minimal keystrokes, with just one key binding.
" `s{char}{label}`
nmap s <Plug>(easymotion-overwin-f)

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" Custom keybindings.

let mapleader = "," " Map leader to comma.

" Custom options.

" Do not automatically insert a leading comment character after pressing 'o' on a commented line.
autocmd FileType * setlocal formatoptions-=o
