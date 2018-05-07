filetype plugin indent on

" Reload vimrc immediately when saved.
autocmd! bufwritepost .vimrc source ~/.vimrc

set encoding=utf-8
set spelllang=en_us
set fileformat=unix

set background=dark
colorscheme dark_eyes

let g:mapleader=','


""" Syntax and Indentation

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
augroup all-files
  autocmd!
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
augroup END

set showcmd
set nobackup
set ruler
set hidden
set wildmenu
set wildmode=list:longest
set wildignore+=*DS_Store*

set linebreak

set number
nnoremap <leader>n :set invnumber<CR>


""" Search Related Settings

" Search down into subdirecties
set path+=**

set hlsearch
noremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>
set incsearch
set showmatch
set ignorecase
set smartcase
" uppercase previously typed word and continue on.
inoremap <c-u> <esc>viwUea

set visualbell t_vb=
set novisualbell

set backspace=indent,eol,start
set complete-=i
set complete+=kspell

set ttimeout
set ttimeoutlen=100

set history=200

set display+=lastline

" Copies into Mac OS X clipboard for pasting.
set clipboard=unnamed

" Causes % to navigate XML tags and Ruby loops.
runtime macros/matchit.vim

" Request terminal version string (for xterm)
set t_RV=

" Do not display banner in Netrw (file browsing).
" See netrw-browse-maps for more info.
let g:netrw_banner=0

" Handle my common command typos.
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
" This doesn't do what I want, but at least it doesn't open up a file called "3" for editing.
cnoreabbrev <expr> e3 ((getcmdtype() is# ':' && getcmdline() is# 'e3')?('3'):(''))


"" Visual star search ... make *|# act upon the current visual selection.
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>

function! s:VSetSearch()
  let s:temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
  let @s = s:temp
endfunction


" Push Quickfix list into args
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
  let s:buffer_numbers = {}
  for s:quickfix_item in getqflist()
    let s:buffer_numbers[s:quickfix_item['bufnr']] = bufname(s:quickfix_item['bufnr'])
  endfor
  return join(map(values(s:buffer_numbers), 'fnameescape(v:val)'))
endfunction


" Handle Nexpose vuln check files as XML.
augroup nexpose
  autocmd!
  autocmd BufNewFile,BufRead *.vck set filetype=xml
augroup END


" When editing a file, always jump to the last known cursor position.
augroup all-files
  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
augroup END

" Maintain some set-up between sessions
set sessionoptions=blank,buffers,curdir,help,resize,tabpages,winsize


"" Persistent Undo
if has('persistent_undo') && !isdirectory(expand('~').'/.vim/backups')
  silent !mkdir ~/.vim/backups > /dev/null 2>&1
  set undodir=~/.vim/backups
  set undofile
endif

" Strip all trailing whitespace, but doesn't include MSWin Returns
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" Strip double-spaces (like from a formatted paste)
nnoremap <leader>p :%s/\(\S \) \+/\1/g<CR>

" Format JSON (python style).
nnoremap <leader>j :%!python3 -m json.tool<CR>

" Force save when using a read-only file
cnoremap sudow w !sudo dd of=%

" Use j and k to navigate pop-up (omnicomplete).
inoremap <expr> j ((pumvisible())?("\<C-n>"):("j"))
inoremap <expr> k ((pumvisible())?("\<C-p>"):("k"))


""" Slime

let g:slime_target = 'tmux'
let g:slime_paste_file = tempname()


""" Hg options

augroup mercurial
  autocmd!
  autocmd Filetype hgcommit setlocal spell textwidth=72
augroup END


""" Git options

augroup git
  autocmd!
  autocmd Filetype gitcommit setlocal spell textwidth=72
augroup END

" function! s:Branch()
"   let s:branch = system("git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* //'")
"   if branch != ''
"     return substitute(substitute(branch, '\n', '', 'g'), 'daines.', '', 'g')
"   en
"   return ''
" endfunction
" Output branch name to the second line of the commit message.
" command! -nargs=0 Branch put=s:Branch()

" autocmd Filetype gitcommit Branch
" autocmd Filetype gitcommit execute "normal ggO"


""" Erlang options.

augroup erlang
  autocmd!
  autocmd BufRead,BufNewFile *.erl,*.es.*.hrl,*.yaws,*.xrl set expandtab
  autocmd BufNewFile,BufRead *.erl,*.es,*.hrl,*.yaws,*.xrl setf erlang

  " Highlight when a comma is not followed by a space.
  autocmd FileType erlang match SyntaxHighlight /,[ \n]\@!/

  " Highlight when a pipe is not surrounded by spaces.
  " autocmd FileType erlang match SyntaxHighlight /[ |]\@!|[ |]\@!/
augroup END

highlight SyntaxHighlight ctermbg=darkblue guibg=darkblue

set wildignore+=*/tmp/*,*.so,*.swp,*.beam

let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.git$',
  \ 'file': '\v\.(beam|png|jpg)$',
  \ }


""" Clojure options.

let g:clj_highlight_builtins = 1

augroup clojure
  autocmd!
  autocmd BufWritePre *.clj :%s/\s\+$//e
  autocmd Filetype clojure setlocal textwidth=78
augroup END

set wildignore+=*/target/*

"" paredit

" Don't insert empty line before closing parens on <Enter>
let g:paredit_electric_return = 0

"" sexp

nnoremap <Space> <Nop>
let g:maplocalleader=' '

"" rainbow_parentheses.vim

augroup lisp
  autocmd!
  autocmd Syntax clojure RainbowParenthesesLoadRound
  autocmd BufEnter *.clj RainbowParenthesesToggle
  autocmd BufLeave *.clj RainbowParenthesesToggle
augroup END

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


""" OCaml Options

let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute 'set rtp+=' . g:opamshare . '/merlin/vim'

if executable('ocamlmerlin') && has('python')
  let s:ocamlmerlin = substitute(system('opam config var share'), '\n$', '', '''') . '/ocamlmerlin'
  execute 'set rtp+='.s:ocamlmerlin.'/vim'
  execute 'set rtp+='.s:ocamlmerlin.'/vimbufsync'
endif

" let g:ocp_indent_vimfile = system("opam config var share")
" let g:ocp_indent_vimfile = substitute(g:ocp_indent_vimfile, '[\r\n]*$', '', '')
" let g:ocp_indent_vimfile = g:ocp_indent_vimfile . "/vim/syntax/ocp-indent.vim"
" autocmd FileType ocaml exec ":source " . g:ocp_indent_vimfile


""" Ruby Options

" Allows gf to jump to Ruby requires.
set suffixesadd+=.rb

augroup ruby
  autocmd!
  " autoindent with two spaces, always expand tabs
  autocmd FileType ruby,yaml set ai sw=2 sts=2 et

  autocmd BufWritePre *.rb :%s/\s\+$//e
augroup END


compiler ruby


""" Text options

augroup text
  autocmd!
  autocmd FileType text setlocal nosmartindent
  autocmd FileType text :set spl=en_us spell
  " Force markdown over modula2
  autocmd BufNewFile,BufReadPost *.md set filetype=markdown
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd FileType markdown setlocal spell
  autocmd BufRead,BufNewFile *.md setlocal textwidth=78
augroup END

iabbrev teh the

" Wrap selection with quotation marks.
vnoremap <leader>" <esc>`>a"<esc>`<i"<esc>
vnoremap <leader>' <esc>`>a'<esc>`<i'<esc>
vnoremap <leader>` <esc>`>a`<esc>`<i`<esc>
nnoremap <leader>" viw<esc>`>a"<esc>`<i"<esc>
nnoremap <leader>' viw<esc>`>a'<esc>`<i'<esc>
nnoremap <leader>` viw<esc>`>a`<esc>`<i`<esc>


""" HTML Options

augroup html
  autocmd!
  autocmd BufNewFile *.html source ~/.vim/ftplugin/htmltemplate.vim
augroup END


""" JavaScript Options

augroup javascript
  autocmd!
  autocmd BufNewFile,BufRead *.json setf javascript
augroup END


""" TagList Options

let g:Tlist_Use_Right_Window=1
let g:Tlist_Enable_Fold_Column=0
let g:Tlist_Show_One_File=1 " especially with this one
let g:Tlist_Compact_Format=1
let g:Tlist_Ctags_Cmd='/usr/local/bin/ctags'
set updatetime=1000
nmap ,t :!(cd %:p:h;ctags *)& " Maps the updates of tags to key ,t.
set tags=tags; " The ';' at the end will cause the ctags plugin to search for current dir and above dirs until it find a tag file.
nnoremap <leader>T :TlistToggle<CR>
nnoremap <f5> :!ctags -R<CR> " Refresh ctags

let g:gutentags_cache_dir = '~/.tags_cache'


""" Gradle Options
augroup groovy
  autocmd!
  autocmd BufNewFile,BufRead *.gradle setf groovy
augroup END


""" Elm Options
let g:elm_format_autosave=1


""" Nerdcommenter

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1


""" ALE

" Enable completion where available.
let g:ale_completion_enabled = 1

" Navigate to ALE errors.
nmap <silent> <C-k> <Plug>(ale_previous)
nmap <silent> <C-j> <Plug>(ale_next)

" Only lint on save.
let g:ale_lint_on_text_changed = 'never'


""" fzf (fuzzy finder)
set runtimepath+=/usr/local/opt/fzf


" Put these lines at the very end of your vimrc file.

" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall
" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL
