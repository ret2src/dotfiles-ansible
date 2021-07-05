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

" Heuristically set buffer indentation options.
Plug 'tpope/vim-sleuth'

" Comment stuff out.
Plug 'tpope/vim-commentary'

" Lean & mean status/tabline for vim.
Plug 'vim-airline/vim-airline'

" Accelerate writing HTML.
Plug 'mattn/emmet-vim', { 'for': 'html' }

" Initialize plugin system.
call plug#end()
