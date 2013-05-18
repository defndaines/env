filetype off
call pathogen#runtime_append_all_bundles()
filetype plugin indent on

set nocompatible

set modelines=0  " What is modelines?

set encoding=utf-8
set spelllang=en_us

colorscheme slate

" Syntax and indent
syntax on
set showmatch
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smarttab
set autoindent " Copy indent from the previous row
set si " Smart indent
" set cindent " alternative to smartindent
set wrap
" set textwidth=79 " Forces newlines on long lines.

" Turn off auto-commenting
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

set scrolloff=3

set showcmd
set nobackup
set ruler
set wildmenu
set wildmode=list:longest
" set laststatus=2

set linebreak

" Search related settings
set hlsearch
noremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>
set incsearch
set showmatch
set ignorecase
set smartcase

set visualbell t_vb=
set novisualbell

set backspace=indent,eol,start

set history=200
set background=dark

" Causes % to navigate XML tags and Ruby loops.
runtime macros/matchit.vim
" Allows gf to jump to Ruby requires.
set suffixesadd+=.rb

" Loads vim-repeat, vim-surround, etc. (anything in ~/.vim/bundle/ dir).
call pathogen#infect()

set t_RV=

" Use different symbols for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬
" set list

" Autosave when focus changes
" au FocusLost * :wa

augroup ft_javascript
  au!
  au FileType javascript setlocal foldmethod=marker
  au FileType javascript setlocal foldmarker={,}
augroup END

" Visual star search ... make *|# act upon the current visual selection.
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>

function! s:VSetSearch()
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

" Useful for Ruby
runtime! macros/matchit.vim

augroup myfiletypes
  " Clear old autocmds in group
  autocmd!
  " autoindent with two spaces, always expand tabs
  autocmd FileType ruby,eruby,yaml set ai sw=2 sts=2 et
augroup END

" Strip all trailing whitespace, but doesn't include MSWin Returns
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" Clojure options.
let g:slime_target = "tmux"

autocmd Syntax clojure RainbowParenthesesLoadRound
autocmd BufEnter *.clj RainbowParenthesesToggle
autocmd BufLeave *.clj RainbowParenthesesToggle

let g:rbpt_colorpairs = [
    \ ['magenta',     'purple1'],
    \ ['cyan',        'magenta1'],
    \ ['green',       'slateblue1'],
    \ ['yellow',      'cyan1'],
    \ ['red',         'springgreen1'],
    \ ['magenta',     'green1'],
    \ ['cyan',        'greenyellow'],
    \ ['green',       'yellow1'],
    \ ['yellow',      'orange1'],
    \ ]
let g:rbpt_max = 9
