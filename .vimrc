filetype off
call pathogen#infect()
filetype plugin indent on

set nocompatible

" Reload vimrc if edited
autocmd! bufwritepost .vimrc source ~/.vimrc

set encoding=utf-8
set spelllang=en_us
set fileformat=unix

colorscheme slate  " for gvim
set background=dark

" Syntax and indent
syntax on
set showmatch
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smarttab
set autoindent " Copy indent from the previous row
set smartindent
set wrap
" set textwidth=79 " Forces newlines on long lines.

set scrolloff=2
set sidescrolloff=10

" Turn off auto-commenting
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

set showcmd
set nobackup
set ruler
set wildmenu
set wildmode=list:longest
" set laststatus=2

set linebreak

" Search related settings
set hlsearch
noremap <esc> :noh<return><esc>
noremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>
set incsearch
set showmatch
set ignorecase
set smartcase

set visualbell t_vb=
set novisualbell

set backspace=indent,eol,start

set history=200

" Causes % to navigate XML tags and Ruby loops.
runtime macros/matchit.vim

" Loads vim-repeat, vim-surround, etc. (anything in ~/.vim/bundle/ dir).
call pathogen#infect()

set t_RV=

" Visual star search ... make *|# act upon the current visual selection.
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>

function! s:VSetSearch()
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

" Push Quickfix list into args
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction

au BufNewFile,BufRead *.vck set filetype=xml

" When editing a file, always jump to the last known cursor position.
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

" Maintain some setup between sessions
set sessionoptions=blank,buffers,curdir,help,resize,tabpages,winsize

" Strip all trailing whitespace, but doesn't include MSWin Returns
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" Refresh ctags
nnoremap <f5> :!ctags -R<CR>

" Clojure options.

let g:slime_target = "tmux"
let clj_highlight_builtins = 1

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

" Ruby Options

runtime! macros/matchit.vim

" Allows gf to jump to Ruby requires.
set suffixesadd+=.rb

augroup myfiletypes
  " Clear old autocmds in group
  autocmd!
  " autoindent with two spaces, always expand tabs
  autocmd FileType ruby,eruby,yaml set ai sw=2 sts=2 et
augroup END

compiler ruby

" Cucumber options

autocmd FileType cucumber :set spl=en_us spell

" Text options

autocmd FileType text setlocal nosmartindent
autocmd FileType text :set spl=en_us spell

" JavaScript Options

augroup ft_javascript
  au!
  au FileType javascript setlocal foldmethod=marker
  au FileType javascript setlocal foldmarker={,}
augroup END
