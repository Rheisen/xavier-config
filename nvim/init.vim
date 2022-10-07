" Plugins ( :PlugInstall )
" (after a first time install, press `<space> so` to re-source the config)
" - Plug Onedark, provides the neovim color scheme.
" - Plug FZF, provides fuzzy finding capabilities.
" - Plug RG, provides fast text searching.
" - Plug Airline, provides an improved status bar.
" - Plug Signify, provides git signs in the gutter.
" - Plug Fugitive, provides git interactions within neovim.
" - Plug Endwise, provides auto completion to end certain structures.
" - Plug Commentary, provides quick comment and uncomment commands.
" - Plug Surround, provides motions for surrounding selections.
" - Plug NERDTree, provides a file explorer menu within neovim.
" - Plug Devicons, provides devicons for NERDTree.
" - Plug Syntastic, provides syntax checking and displays errors.
" - Plug VimGo, provides Go utilities within neovim.
" - Plug Polyglot, provides syntax styling for numerous languages.
" - Plug Conquer of Completion (coc), provides code completion.
" - Plug Rust, provides Rust syntax highlighting, works with Syntastic.
call plug#begin("~/.vim/plugged")
    Plug 'https://github.com/joshdick/onedark.vim.git'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'jremmen/vim-ripgrep'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'mhinz/vim-signify'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-endwise'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-surround'
    Plug 'scrooloose/nerdtree'
    Plug 'ryanoasis/vim-devicons'
    Plug 'dense-analysis/ale', { 'on': 'ALEToggle' }
    Plug 'vim-syntastic/syntastic', { 'on': 'SyntasticToggleMode' }
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
    Plug 'sheerun/vim-polyglot'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    " Install CocExtensions as needed (manage with :CocList extensions)
    " :CocInstall coc-rls
    " :CocInstall coc-tsserver
    " :CocInstall coc-eslint
    " :CocInstall coc-prettier
    " :CocInstall coc-go
    " gem install solargraph
    " :CocInstall coc-solargraph
    " :CocInstall coc-java
    Plug 'rust-lang/rust.vim'
call plug#end()"Config Section

" Colorscheme configuration
if (has("termguicolors"))
    set termguicolors
endif
syntax enable
try
    colorscheme onedark
catch /^Vim\%((\a\+)\)\=:E185/
    colorscheme default
endtry

" Behavioral configuration
set autoread
set rtp+=/usr/local/opt/fzf
set updatetime=100
set timeout timeoutlen=3000 ttimeoutlen=100

" Window configuration
set number
set showcmd
set signcolumn=yes
set colorcolumn=120

let g:fzf_preview_window = ['right:50%', 'ctrl-/']

" Spacing configuration
autocmd FileType ruby setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd FileType javascript setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd FileType javascriptreact setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd FileType typescript setlocal tabstop=2 softtabstop=2 shiftwidth=2
autocmd FileType typescriptreact setlocal tabstop=2 softtabstop=2 shiftwidth=2
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

" Linting
let g:ale_linters = {
            \ 'ruby': ['standardrb', 'rubocop'],
            \ 'javascript': ['eslint', 'prettier'],
            \ }
let g:ale_fixers = {
            \ 'ruby': ['rubocop'],
            \ }

" Leader key configuration
" - Space key leader key
" - space + sc: create new tab and open the nvim config file (this)
" - space + so: source the nvim config file (this)
" - space + ff: fuzzy find
" - space + fg: fuzzy find git files
" - space + . : fuzzy find files in current directory
" - space + ft: fuzzy find text
" - space + n : turn off highlighting
" - space + y : yank into clipboard
" - space + p : paste from clipboard
" - space + t : NerdTree Toggle
" - space + gd: goto definition
" - space + gy: goto type definition
" - space + gi: goto implementation
" - space + gr: goto references
" - space + K : show documentation
" - space + rn: rename symbol
let mapleader = "\<Space>"

" Utility
nnoremap <leader>i m0o<ESC>`0
nnoremap <leader>I m0O<ESC>`0

nnoremap <leader>sc :tabedit $MYNVIM<CR>
nnoremap <leader>so :source $MYNVIM<CR>

" Linting
nnoremap <leader>l :ALEToggle<CR>
au FileType rust noremap <buffer> <leader>l :SyntasticToggleMode<CR>

" Tabs
nnoremap <silent> <leader>fn :tabedit<CR>

" Fixing
nnoremap <leader>L :ALEFix<CR>

" File searching
nnoremap <silent> <leader>ff :Files<CR>
nnoremap <silent> <leader>fg :GFiles<CR>
nnoremap <silent> <leader>. :Files <C-r>=expand("%:h")<CR>/<CR>
if filereadable('config/routes.rb')
    nnoremap <silent> <leader>fc :Files app/controllers<cr>
    nnoremap <silent> <leader>fm :Files app/models<cr>
    nnoremap <silent> <leader>fv :Files app/views<cr>
    nnoremap <silent> <leader>fs :Files spec<cr>
endif

" Text searching
" Excludes vendor/*, .node_modules/*, and *.class files
" function! RipgrepFzf(query, fullscreen)
"   let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
"   let initial_command = printf(command_fmt, shellescape(a:query))
"   let reload_command = printf(command_fmt, shellescape('{q}'))
"   let spec = {'options': ['--query', a:query, '--bind', 'change:reload:'.reload_command]}
"   call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
" endfunction
" command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
"
let $FZF_PREVIEW_COMMAND="COLORTERM=truecolor bat --style=numbers --color=always {}"

command! -bang -nargs=* RG
  \ call fzf#vim#grep(
  \   'rg --column --hidden --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

nnoremap <silent> <leader>ft :RG<CR> 

" Highlighting
nnoremap <silent> <leader>n :noh<cr>

"Buffers
nnoremap <silent> <leader>b :Buffers<cr>

" System Copy / Paste
nnoremap <leader>y "+y
nnoremap <leader>p "+p
nnoremap <leader>P "+P

" Airline configuration
let g:airline_theme='onedark'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#tab_nr_type = 2
let g:airline#extensions#tabline#tabs_label = 't'
let g:airline#extensions#tabline#buffers_label = 'b'

"Syntastic configuration
let g:syntastic_ruby_checkers = ['rubocop', 'mri']

" NerdTree configuration
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''
let NERDTreeWinSize = 60
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

nnoremap <silent><expr> <c-space> coc#refresh()

let g:go_def_mapping_enabled = 0
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <leader>r <Plug>(coc-format-selected)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Rename symbol
nmap <leader>rn <Plug>(coc-rename)

let g:coc_global_extensions = []

if filereadable('.eslintrc.json')
    let g:coc_global_extensions += ['coc-eslint']
endif

if filereadable('.prettierrc')
    let g:coc_global_extensions += ['coc-prettier']
endif

" Vim-go configuration
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
