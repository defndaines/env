filetype off
call pathogen#infect()
filetype plugin indent on

set nocompatible

" Reload vimrc if edited
autocmd! bufwritepost .vimrc source ~/.vimrc

set encoding=utf-8
set spelllang=en_us
set fileformat=unix

colorscheme elflord
set background=dark

" Syntax and indent
syntax on
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smarttab
set autoindent " Copy indent from the previous row
set smartindent
set wrap

set scrolloff=2
set sidescrolloff=10

" Use <F2> to toggle paste mode
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" Turn off auto-commenting
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

set showcmd
set nobackup
set ruler
set hidden
set wildmenu
set wildmode=list:longest
set wildignore+=*DS_Store*

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
set complete-=i

set ttimeout
set ttimeoutlen=100

set history=200

set display+=lastline

" Copies into Mac OS X clipboard for pasting.
set clipboard=unnamed

" Causes % to navigate XML tags and Ruby loops.
runtime macros/matchit.vim

set t_RV=

" Handle my common command typos.
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
" This doesn't do what I want, but at least it doesn't open up a file called "3" for editing.
cnoreabbrev <expr> e3 ((getcmdtype() is# ':' && getcmdline() is# 'e3')?('3'):(''))

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

" Handle Nexpose vuln check files as XML.
au BufNewFile,BufRead *.vck set filetype=xml

" When editing a file, always jump to the last known cursor position.
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

" Maintain some set-up between sessions
set sessionoptions=blank,buffers,curdir,help,resize,tabpages,winsize

" Persistent Undo
if has('persistent_undo') && !isdirectory(expand('~').'/.vim/backups')
  silent !mkdir ~/.vim/backups > /dev/null 2>&1
  set undodir=~/.vim/backups
  set undofile
endif

" Strip all trailing whitespace, but doesn't include MSWin Returns
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" Format JSON (python style).
nnoremap <leader>j :%!python -m json.tool<CR>

" Force save when using a read-only file
cnoremap sudow w !sudo dd of=%

" Use j and k to navigate pop-up (omnicomplete).
inoremap <expr> j ((pumvisible())?("\<C-n>"):("j"))
inoremap <expr> k ((pumvisible())?("\<C-p>"):("k"))

" Snippets
let g:UltiSnipsExpandTrigger="<tab>"

" Hg options

autocmd Filetype hgcommit setlocal spell textwidth=72

" Git options

autocmd Filetype gitcommit setlocal spell textwidth=72
autocmd BufRead,BufNewFile *.md set filetype=mkd
autocmd BufRead,BufNewFile *.markdown set filetype=mkd
autocmd FileType markdown setlocal spell
autocmd BufRead,BufNewFile *.md setlocal textwidth=80

" function! s:Branch()
"   let branch = system("git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* //'")
"   if branch != ''
"     return substitute(substitute(branch, '\n', '', 'g'), 'daines.', '', 'g')
"   en
"   return ''
" endfunction
" Output branch name to the second line of the commit message.
" command! -nargs=0 Branch put=s:Branch()

" autocmd Filetype gitcommit Branch
" autocmd Filetype gitcommit execute "normal ggO"

" Erlang options.

highlight SyntaxHighlight ctermbg=darkblue guibg=darkblue
" Highlight when a comma is not followed by a space.
autocmd FileType erlang match SyntaxHighlight /,[ \n]\@!/
" Highlight when a pipe is not surrounded by spaces.
" autocmd FileType erlang match SyntaxHighlight /[ |]\@!|[ |]\@!/

set wildignore+=*/tmp/*,*.so,*.swp,*.beam
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.git$',
  \ 'file': '\v\.(beam|png|jpg)$',
  \ }

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

" OCaml Options

if executable('ocamlmerlin') && has('python')
  let s:ocamlmerlin = substitute(system('opam config var share'), '\n$', '', '''') . "/ocamlmerlin"
  execute "set rtp+=".s:ocamlmerlin."/vim"
  execute "set rtp+=".s:ocamlmerlin."/vimbufsync"
endif

let g:ocp_indent_vimfile = system("opam config var share")
let g:ocp_indent_vimfile = substitute(g:ocp_indent_vimfile, '[\r\n]*$', '', '')
let g:ocp_indent_vimfile = g:ocp_indent_vimfile . "/vim/syntax/ocp-indent.vim"
autocmd FileType ocaml exec ":source " . g:ocp_indent_vimfile

" Ruby Options

" Allows gf to jump to Ruby requires.
set suffixesadd+=.rb

augroup myfiletypes
  " Clear old autocmds in group
  autocmd!
  " autoindent with two spaces, always expand tabs
  autocmd FileType ruby,yaml set ai sw=2 sts=2 et
augroup END

compiler ruby

" Text options

autocmd FileType text setlocal nosmartindent
autocmd FileType text :set spl=en_us spell
" Force markdown over modula2
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" HTML Options

autocmd BufNewFile *.html source ~/.vim/ftplugin/htmltemplate.vim

" JavaScript Options

au BufNewFile,BufRead *.json setf javascript

" TagList Options

let Tlist_Use_Right_Window=1
let Tlist_Enable_Fold_Column=0
let Tlist_Show_One_File=1 " especially with this one
let Tlist_Compact_Format=1
let Tlist_Ctags_Cmd='/usr/local/bin/ctags'
set updatetime=1000
nmap ,t :!(cd %:p:h;ctags *)& " Maps the updates of tags to key ,t.
set tags=tags; " The ';' at the end will cause the ctags plugin to search for current dir and above dirs until it find a tag file.
nnoremap <leader>T :TlistToggle<CR>
nnoremap <f5> :!ctags -R<CR> " Refresh ctags

" Gradle Options
au BufNewFile,BufRead *.gradle setf groovy

" Elm Options
let g:elm_format_autosave=1
