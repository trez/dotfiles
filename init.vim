
if has('nvim') || has('termguicolors')
  set termguicolors
endif

if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.config/nvim/plugged')

" Visuals
" ===================================================================================================================
Plug 'vim-airline/vim-airline'                  " Lean status/tabs bar
Plug 'vim-airline/vim-airline-themes'           " Themes
Plug 'kien/rainbow_parentheses.vim'             " Colorfully shows which parentheses match.
Plug 'ryanoasis/vim-devicons'                   " Icons for your plugins
Plug 'Valloric/MatchTagAlways'                  " Highlights matching XML/HTML tag.
Plug 'jaxbot/semantic-highlight.vim'            " Every variable is a different color.
Plug 'flazz/vim-colorschemes'                   " pack of colorschemes
Plug 'crusoexia/vim-monokai'                    " theme
Plug 'w0ng/vim-hybrid'                          " dark colorscheme
Plug 'dracula/vim'                              " dark theme
Plug 'gosukiwi/vim-atom-dark'                   " Atom inspired dark theme.
Plug 'airblade/vim-gitgutter'                   " Shows line status in the gutter.
Plug 'Xuyuanp/nerdtree-git-plugin'              " Show git status for files in nerdtree.
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'  " Some colors in the nerdtree.
Plug 'junegunn/goyo.vim'                        " Distraction free writing vim, :GoyoEnter
Plug 'junegunn/limelight.vim'                   " Highlight current paragraph, :Limelight!
Plug 'ap/vim-css-color'                         " Show colors in colors eg. #777777 #c0ffee
Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }

" Utility
" ===================================================================================================================
Plug 'scrooloose/nerdtree'                      " eg. C-f to open File tree viewer
Plug 'tpope/vim-commentary'                     " eg. gcc for comment in/out line
Plug 'tpope/vim-repeat'                         " eg. use . for repeating plugin commands
Plug 'tpope/vim-surround'                       " eg. cs{( for change surrounding {} to ()
Plug 'tpope/vim-unimpaired'                     " eg. [<Space> for enter newline at cursor, complementary mappings.
Plug 'junegunn/vim-easy-align'                  " eg. gaip= for aligning lines by =
Plug 'tpope/vim-fugitive'                       " eg. :Gdiff use git from vim, criminally good.
Plug 'jlanzarotta/bufexplorer'                  " eg. <Leader>be normal open and more!
Plug 'rbgrouleff/bclose.vim'                    " eg. <Leader>bd Delete buffer without effecting window setup.
Plug 'vimwiki/vimwiki'                          " eg. :vimwiki for Nice wiki functionality.
Plug 'preservim/tagbar'                         " eg. :TagbarToggle , Ctags browser tool. Mapped to F8
Plug 'ctrlpvim/ctrlp.vim'                       " eg. Ctrl-p for quick file search.
Plug 'easymotion/vim-easymotion'                " eg.
Plug 'jiangmiao/auto-pairs'                     " eg. Alt-p for toggle, Automatically adds matching end for [('

" Tool specific support
" ===================================================================================================================
Plug 'neoclide/coc.nvim', {'branch': 'release'} " Make your Neovim as smart as VSCode.
Plug 'dansomething/vim-eclim'                   " Eclim support
Plug 'benmills/vimux'                           " tmux control

" Language specific
" ===================================================================================================================
Plug 'neovimhaskell/haskell-vim'
Plug 'derekwyatt/vim-scala'
Plug 'leafgarland/typescript-vim'
Plug 'Quramy/tsuquyomi'                         " Typescript
Plug 'jason0x43/vim-js-indent'
Plug 'elixir-lang/vim-elixir'
Plug 'nvie/vim-flake8'                          " pylinting
Plug 'pangloss/vim-javascript'                  " JSX highlight
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'davidhalter/jedi-vim'                     " Python autocompletion
Plug 'mxw/vim-jsx'                              " JSX highlight

call plug#end()

set hidden
set foldmethod=indent
set foldlevel=2
set nofoldenable
set scrolloff=25
set mouse=v
let mapleader=","
set directory=~/.config/nvim/backup
set backupdir=~/.config/nvim/backup   " keep swap files here
set relativenumber
set number
set backspace=2
colorscheme challenger_deep
set background=dark
syntax on
filetype plugin on
set nocompatible
set shell=/bin/bash
set laststatus=2
set noshowmode
set smarttab
set cindent
set nobackup            " (coc.nvim) Some servers have issues with backup files
set nowritebackup       " (coc.nvim) Some servers have issues with backup files
set updatetime=300      " (coc.nvim) You will have a bad experience with diagnostic messages with the default
set shortmess+=c        " (coc.nvim) Don't give |ins-completion-menu| messages.
set signcolumn=yes      " (coc.nvim) Always show signcolumns
set tabstop=4
set shiftwidth=4
set expandtab
set t_Co=256

filetype off                  " required by coc.nvim

hi Normal ctermbg=none guibg=none
au BufRead,BufNewFile *.sbt,*.sc set filetype=scala

" Draw a line at 80 columns
" set colorcolumn=80
" highlight ColorColumn ctermbg='darkgray' guibg='darkgray'

" Remappings
nnoremap <C-N> :call NumberToggle()<cr>
nnoremap <C-T> :call WhitespaceToggle()<cr>
xmap ga <Plug>(EasyAlign)       " Start interactive EasyAlign in visual mode (e.g. vipga)
nmap ga <Plug>(EasyAlign)       " Start interactive EasyAlign for a motion/text object (e.g. gaip)
map <C-F> :NERDTreeToggle<CR>
nmap <C-h> :bprev<CR>           " Move to the tab to the left
nmap <C-l> :bnext<CR>           " Move to the tab to the right

" Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

" Go to buffer 1/2/...
nnoremap <Leader>1 :1b<CR>
nnoremap <Leader>2 :2b<CR>
nnoremap <Leader>3 :3b<CR>
nnoremap <Leader>4 :4b<CR>
nnoremap <Leader>5 :5b<CR>
nnoremap <Leader>6 :6b<CR>
nnoremap <Leader>7 :7b<CR>
nnoremap <Leader>8 :8b<CR>
nnoremap <Leader>9 :9b<CR>

" Tagbar configuration.
nmap <F8> :TagbarToggle<CR>

" nerdtree config
" ===================================================================================================================
let g:NERDTreeGitStatusIndicatorMapCustom = {
    \ "Modified"  : "ᵐ",
    \ "Staged"    : "ˢ",
    \ "Untracked" : "ᵘ",
    \ "Renamed"   : "ʳ",
    \ "Unmerged"  : "ᶴ",
    \ "Deleted"   : "ˣ",
    \ "Dirty"     : "˜",
    \ "Clean"     : "ᵅ",
    \ "Unknown"   : "?"
    \ }

" gitgutter config
" ===================================================================================================================
let g:gitgutter_max_signs = 1500    " show more signs

" Rainbow parentheses config
" ===================================================================================================================
let g:rainbow_active = 1
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]

au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" Airline config
" ===================================================================================================================
let g:airline#extensions#tabline#enabled = 1    " Enable the list of buffers
let g:airline#extensions#tabline#fnamemod = ':t' " Show just the filename
let g:airline_powerline_fonts = 1

" Limelight config
" ===================================================================================================================
" Color name (:help cterm-colors) or ANSI code
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240

" Color name (:help gui-colors) or RGB color
let g:limelight_conceal_guifg = 'DarkGray'
let g:limelight_conceal_guifg = '#777777'

" SemanticHighlight config
" ===================================================================================================================
let g:semanticTermColors = [28,1,2,3,4,5,6,7,25,9,10,34,12,13,14,15,30,125,124,31]
au BufRead,BufNewFile *.py :SemanticHighlight

" Tagbar config
" ===================================================================================================================
let g:tagbar_vertical = 30
let g:tagbar_sort = 0
let g:tagbar_compact = 1
let g:tagbar_show_linenumbers = 1

" Goyo config
" ===================================================================================================================
let g:goyo_width = 120

" Jedi config
" ===================================================================================================================
let g:jedi#popup_on_dot = 0     " Don't start autocompletion directly at '.'
let g:jedi#completions_command = "<C-k>"
let g:jedi#completions_enabled = 0  " use deoplete instead
let g:deoplete#sources#jedi#enable_typeinfo = 0  " disabled for speed

" Vimwiki config
" ===================================================================================================================
let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.wiki'}]
let g:vimwiki_table_mappings=0    " screws with you when you edit Tables
let g:vimwiki_table_auto_fmt=0    " screws with you when you edit Tables

" vim-unimpared config
" ===================================================================================================================
" Insert empty line without being in insert mode.
" nmap < [
" nmap > ]
" omap < [
" omap > ]
" xmap < [
" xmap > ]

" coc config
" ===================================================================================================================
" (coc.nvim) Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" (coc.nvim) Used in the tab autocompletion for coc
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" (coc.nvim) Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" (coc.nvim) Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" (coc.nvim) Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" (coc.nvim) Use K to either doHover or show documentation in preview window
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

" Random function definitions
" ===================================================================================================================
" Function for number toggle
function! NumberToggle()
  if(&relativenumber == 1)
    set norelativenumber
  else
    set relativenumber
  endif
endfunc


" Function for whitespace toggle
function! WhitespaceToggle()
  set listchars=eol:¬,tab:--,trail:~,extends:>,precedes:<
  if(&list ==1)
    set nolist
  else
    set list
  endif
endfunc

" Non-mapped function for tab toggles
function! TabToggle()
  if &expandtab
    set noexpandtab
  else
    set expandtab
  endif
endfunc

" Search for selected text.
" http://vim.wikia.com/wiki/VimTip171
let s:save_cpo = &cpo | set cpo&vim
if !exists('g:VeryLiteral')
  let g:VeryLiteral = 0
endif
function! s:VSetSearch(cmd)
  let old_reg = getreg('"')
  let old_regtype = getregtype('"')
  normal! gvy
  if @@ =~? '^[0-9a-z,_]*$' || @@ =~? '^[0-9a-z ,_]*$' && g:VeryLiteral
    let @/ = @@
  else
    let pat = escape(@@, a:cmd.'\')
    if g:VeryLiteral
      let pat = substitute(pat, '\n', '\\n', 'g')
    else
      let pat = substitute(pat, '^\_s\+', '\\s\\+', '')
      let pat = substitute(pat, '\_s\+$', '\\s\\*', '')
      let pat = substitute(pat, '\_s\+', '\\_s\\+', 'g')
    endif
    let @/ = '\V'.pat
  endif
  normal! gV
  call setreg('"', old_reg, old_regtype)
endfunction
