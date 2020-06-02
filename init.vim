" Plugins ( :PlugInstall )
" - Plug 1: Onedark, provides the neovim color scheme.
" - Plug 2: FZF, provides fuzzy finding capabilities.
" - Plug 3: NERDTree, provides a file explorer menu within neovim.
" - Plug 4: Devicons, provides devicons for NERDTree.
" - Plug 5: Syntastic, provides syntax checking and displays errors.
" - Plug 6: Polyglot, provides syntax styling for numerous languages.
" - Plug 7: Conquer of Completion (coc), provides code completion.
" - Plug 8: Rust, provides Rust syntax highlighting, works with Syntastic.
call plug#begin("~/.vim/plugged")
    Plug 'https://github.com/joshdick/onedark.vim.git'
    Plug '/usr/local/opt/fzf'
    Plug 'junegunn/fzf.vim'
    Plug 'scrooloose/nerdtree'
    Plug 'ryanoasis/vim-devicons'
    Plug 'vim-syntastic/syntastic'
    Plug 'sheerun/vim-polyglot'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " :CocInstall coc-rls
    " :CocInstall coc-tsserver
    Plug 'rust-lang/rust.vim'
call plug#end()"Config Section

" Colorscheme configuration
if (has("termguicolors"))
    set termguicolors
endif
syntax enable
colorscheme onedark

" Behavioral configuration
set autoread
set rtp+=/usr/local/opt/fzf

" Window configuration
set number
set showcmd
set signcolumn=yes
set colorcolumn=120

" Spacing configuration
autocmd FileType ruby setlocal ts=2 sts=2 sw=2
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smarttab

set backspace=indent,eol,start
set linebreak

" Updated key configuration
nnoremap 0 ^
nnoremap ^ 0
nmap j gj
nmap k gk

" Leader key configuration
" - Space key leader key
" - space + sc: split plane and open the nvim config file (this)
" - space + so: source the nvim config file (this)
" - space + f: fuzzy find
let mapleader = "\<Space>"

nnoremap <leader>sc :tabedit $MYNVIM<cr>
nnoremap <leader>so :source $MYNVIM<cr>
nnoremap <silent> <leader>f :FZF<cr>
nnoremap <silent> <leader>F :GFiles<cr>
nnoremap <leader>y "+y
nnoremap <leader>p "+p

" NerdTree configuration
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
nnoremap <silent> <leader>t :NERDTreeToggle<CR>

" Code Completion configuration
" - Tab: rotates through completion options
" - Ctrl + space: selects completion option
" - g + d/y/i/r: Goto definition/type-definition/implementation/reference
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

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
