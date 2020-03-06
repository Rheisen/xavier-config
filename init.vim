" Plugins ( :PlugInstall )
" - Plug 1: Onedark, provides the neovim color scheme.
" - Plug 2: NERDTree, provides a file explorer menu within neovim.
" - Plug 3: Devicons, provides devicons for NERDTree.
" - Plug 4: Syntastic, provides syntax checking and displays errors.
" - Plug 5: Conquer of Completion (coc), provides code completion.
" - Plug 6: Rust, provides Rust syntax highlighting, works with Syntastic.
call plug#begin("~/.vim/plugged")
    Plug 'https://github.com/joshdick/onedark.vim.git'
    Plug 'scrooloose/nerdtree'
    Plug 'ryanoasis/vim-devicons'
    Plug 'vim-syntastic/syntastic'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " :CocInstall coc-rls
    Plug 'rust-lang/rust.vim'
call plug#end()"Config Section

" Colorscheme configuration
if (has("termguicolors"))
    set termguicolors
endif
syntax enable
colorscheme onedark

" Window configuration
set number
set showcmd
set signcolumn=yes

" Spacing configuration
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab

set backspace=indent,eol,start
set linebreak

" Updated key configuration
nmap 0 ^

" Leader key configuration
let mapleader = "\<Space>"

" NerdTree configuration
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
nnoremap <silent> <C-b> :NERDTreeToggle<CR>

" Code Completion configuration
" - Tab key rotates through completion options
" - Cmd + space selects completion option

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <c-space> coc#refresh()
