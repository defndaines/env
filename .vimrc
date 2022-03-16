filetype plugin indent on

" Reload vimrc immediately when saved.
autocmd! bufwritepost .vimrc source ~/.vimrc

set encoding=utf-8
set spelllang=en_us,cjk
set fileformat=unix

set background=light
colorscheme PaperColor

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

" Don't redraw screen during macro execution (makes them faster)
set lazyredraw

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

nnoremap <leader>s :set spell!<CR>


""" Search Related Settings

" Search down into subdirectories
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
" set completeopt=menuone,preview,noinsert
set completeopt=menuone,preview

set ttimeout
set ttimeoutlen=100

set history=500

" Move up or down in column to next non-blank line.
nnoremap g<up> ?\%<C-R>=virtcol(".")<CR>v\S<CR>
nnoremap g<down> /\%<C-R>=virtcol(".")<CR>v\S<CR>

" Persistent Undo across sessions
set undofile
set undodir=$VIMDATA/undo
call mkdir(&undodir, 'p')
augroup vimrc
  autocmd!
  autocmd BufWritePre */tmp/* setlocal noundofile
augroup END

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
cnoreabbrev <expr> e3 ((getcmdtype() is# ':' && getcmdline() is# 'e3')?(''):(''))


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

set colorcolumn=98
highlight ColorColumn ctermbg=7 guifg=black

highlight rightMargin term=bold ctermfg=black guifg=brown


" Format XML
command! FormatXML :%!python3 -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"
" command! C14N11 :!xmllint --c14n11 %
nnoremap <leader>x :FormatXML<CR>

" Format JSON
nnoremap <leader>j :%!python3 -m json.tool<CR>1G=G<CR>:call FormatJSON()<CR>
nnoremap <leader>r :call FormatJSON()<CR>

function! FormatJSON()
  " Make sure there are no tabs in the file.
  if search("\t")
    execute '%s/\t/  /g'
  endif
  " Move trailing [ to the next line.
  if search(' \[\n\(  *\)  ')
    execute '%s/ \[\n\(  *\)  /\r\1[ '
  endif
  " Move line-ending { to the next line.
  if search('{\n  *"')
    execute '%s/{\n  *"/{ "/'
  endif
  " Move trailing , to the next line.
  if search(',\n\( *\)  ')
    execute '%s/,\n\( *\)  /\r\1, /'
  endif
  " Move object-defining { to the next line.
  if search('^\( *\)\([^{]*\): {')
    execute '%s/^\( *\)\([^{]*\): {/\1\2:\r\1  {/g'
  endif
  " Move object-defining { to the next line. In while loop to capture depth.
  while search('^\( *\)\(.[^{]*\): {')
    execute '%s/^\( *\)\(.[^{]*\): {/\1\2:\r\1  {/g'
  endwhile
  " if search('\n\( *])\[ .*\n\1]')
    " execute '%s#\n\( *\)\[ \(.*\)\n\1]# [ \2 ]#'
  " endif
endfunction


" Insert the current date
nnoremap <leader>d "=strftime("%Y-%m-%d")<CR>p

" Force save when using a read-only file
cnoremap sudow w !sudo dd of=%

" Use j and k to navigate pop-up (omnicomplete).
inoremap <expr> j ((pumvisible())?("\<C-n>"):("j"))
inoremap <expr> k ((pumvisible())?("\<C-p>"):("k"))


let g:markdown_fenced_languages = ['bash', 'shell=bash', 'sql', 'html', 'css', 'javascript', 'js=javascript', 'json=javascript', 'clojure', 'erlang', 'ruby', 'eruby', 'erb=eruby', 'vim', 'xml', 'yaml']


""" Slime

let g:slime_target = 'tmux'
let g:slime_paste_file = tempname()
" This allows slime to work with tmate!
let g:slime_default_config = {"socket_name": get(split($TMUX, ","), 0), "target_pane": ":.1"}


""" Hg options

augroup mercurial
  autocmd!
  autocmd FileType hgcommit setlocal spell textwidth=72
augroup END


""" Git options

augroup git
  autocmd!
  autocmd FileType gitcommit setlocal spell textwidth=72
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

" autocmd FileType gitcommit Branch
" autocmd FileType gitcommit execute "normal ggO"


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

set wildignore+=*.so,*.swp,*.beam

let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.git$',
  \ 'file': '\v\.(beam|png|jpg)$',
  \ }


""" Clojure options.

let g:clj_highlight_builtins = 1
let g:clojure_special_indent_words = 'deftype,defrecord,reify,proxy,extend-type,extend-protocol,letfn,defcomponent'
let g:clojure_fuzzy_indent_patterns = ['^with', '^def', '^let', '^for-all']
" Don't stop indentation fixes at 100 lines.
let g:clojure_maxlines = 1000
" Causes 1-space indent if there is no argument after a function.
" let g:clojure_align_subforms = 1


augroup clojure
  autocmd!
  autocmd BufWritePre *.clj :%s/\s\+$//e
  autocmd BufWritePre *.clj :%s/\t/  /ge
  autocmd FileType clojure setlocal textwidth=78
  autocmd FileType clojure setlocal lispwords+=fdef
  autocmd BufNewFile,BufReadPost .lein-env set filetype=clojure
augroup END

set wildignore+=*/target/*

" TODO Make this only applicable if editing a Clojure file?
" nnoremap <leader>c :call AddClojureNamespace()<CR>

function! AddClojureNamespace()
  let s:ns = ["(ns " . fnamemodify(expand('%'), ':r:s#^src/##:s#^test/##:gs#/#.#:gs#_#-#')]
  if (expand('%') =~ "test/")
    let s:under_test = fnamemodify(expand('%'), ':r:s#^test/##:s#_test$##:gs#/#.#:gs#_#-#')
    let s:as_var = split(s:under_test, '\.')[-1]
    call add(s:ns, '  "Tests against the ' . s:under_test . ' namespace."')
    call add(s:ns, "  (:require [clojure.test :refer [deftest is testing]]")
    call add(s:ns, "            [" . s:under_test . " :as " . s:as_var . "]))")
  else
    call add(s:ns, '  "TODO: Write a clear explanation of what purpose this namespace serves."')
    call add(s:ns, "  (:require [clojure.spec.alpha :as s]))")
  endif
  call add(s:ns, "")

  let s:failed = append(0, s:ns)
  if (s:failed)
    echo "Problem creating namespace!"
  else
    let &modified = 1
  endif
endfunction

" nnoremap <leader>e :call FormatEDN()<CR>1G=G<CR>

function! FormatEDN()
  " TODO: There are better tools for this, just plug into them (joker?)
  " Separate sequences of strings to separate lines.
  if search('" "')
    execute '%s/" "/"\r"/g'
  endif
  " Break lists of maps onto separate lines.
  if search('} {')
    execute '%s/} {/}\r{/g'
  endif
  " Convert commas into newlines in maps.
  if search(', :')
    execute '%s/, :/\r:/g'
  endif
endfunction

"" Elixir

augroup elixir
  autocmd FileType elixir setlocal textwidth=98
augroup END

nnoremap <leader>z :call OpenElixirTestFile()<CR>

function! OpenElixirTestFile()
  let s:ns = 'test/' . fnamemodify(expand('%'), ':r:s#^lib/##') . '_test.exs'
  execute "edit " . s:ns
endfunction

"" sexp

nnoremap <Space> <Nop>
let g:maplocalleader=' '

"" iced

" Enable vim-iced's default key mapping
let g:iced_enable_default_key_mappings = v:true
" Automatically display expected arguments to the right
" let g:iced_enable_auto_document = 'every'


""" Ruby Options

" Allows gf to jump to Ruby requires.
set suffixesadd+=.rb

augroup ruby
  autocmd!
  autocmd BufWritePre *.rb :%s/\s\+$//e
  autocmd BufWritePre *.rb :%s/\t/  /ge
  " autoindent with two spaces, always expand tabs
  autocmd FileType ruby,yaml set ai sw=2 sts=2 et
  " treat thor files as Ruby
  autocmd BufNewFile,BufReadPost *.thor set filetype=ruby
  autocmd BufRead,BufNewFile *.thor set filetype=ruby
  autocmd BufRead,BufNewFile *.jbuilder set filetype=ruby

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
vnoremap <leader>i <esc>`>a*<esc>`<i*<esc>
vnoremap <leader>b <esc>`>a**<esc>`<i**<esc>


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


""" PHP Options

augroup php
  " set expandtab tabstop=4 shiftwidth=4 softtabstop=4
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


""" Elm Options
let g:elm_format_autosave=1


""" Nerdcommenter

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'


""" VimL and Vader (for Exercism)

function! s:exercism_tests()
  if expand('%:e') ==? 'vim'
    let s:testfile = printf('%s/%s.vader', expand('%:p:h'),
          \ tr(expand('%:p:h:t'), '-', '_'))
    if !filereadable(s:testfile)
      echoerr 'File does not exist: '. s:testfile
      return
    endif
    source %
    execute 'Vader' s:testfile
  else
    let s:sourcefile = printf('%s/%s.vim', expand('%:p:h'),
          \ tr(expand('%:p:h:t'), '-', '_'))
    if !filereadable(s:sourcefile)
      echoerr 'File does not exist: '. s:sourcefile
      return
    endif
    execute 'source' s:sourcefile
    Vader
  endif
endfunction

augroup exercism
  autocmd BufRead *.{vader,vim}
        \ command! -buffer Test call s:exercism_tests()
augroup END


""" ALE

" Enable completion where available.
let g:ale_completion_enabled = 1

" Enable alex for all files
let g:ale_alex_use_global = 1

" Navigate to ALE errors.
nmap <silent> <C-k> <Plug>(ale_previous)
nmap <silent> <C-j> <Plug>(ale_next)

" Only lint on save.
let g:ale_lint_on_text_changed = 'never'

" PHP settings
let g:ale_php_phpstan_level = '7'
let g:phpstan_analyse_level = '7'

let g:ale_linters = {
      \ 'elixir': ['elixir-ls', 'credo'],
      \ 'rust': ['rust-analyzer'],
      \}

let b:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'elixir': ['mix_format'],
      \ 'javascript': ['prettier', 'eslint'],
      \ 'rust': ['rustfmt'],
      \}

let g:ale_elixir_elixir_ls_release = expand("/home/daines/src/elixir-ls/rel/")

let g:ale_elixir_credo_strict = 1

" let g:ale_elixir_elixir_ls_config = {'elixirLS': {'dialyzerEnabled': v:false}

let g:ale_sign_error = '✘'
" let g:ale_sign_warning = '⚠'
" highlight ALEErrorSign ctermbg=NONE ctermfg=red
" highlight ALEWarningSign ctermbg=NONE ctermfg=yellow
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1

noremap <leader>ad :ALEGoToDefinition<CR>
nnoremap <leader>af :ALEFix<CR>
noremap <leader>ar :ALEFindReferences<CR>
nnoremap <leader>K :ALEHover<CR>


""" fzf (fuzzy finder)
set runtimepath+=/usr/local/bin/fzf
nnoremap <C-p> :<C-u>FZF<CR>


""" Grepper
let g:grepper = {}
" let g:grepper.tools = ['rg', 'git, 'grep']
let g:grepper.tools = ['rg']

" Search for the current word.
nnoremap <leader>* :Grepper -cword -noprompt<CR>

" Search for the current selection.
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)


" Put these lines at the very end of your vimrc file.

" Load all plugins now.
" Plugins need to be added to runtimepath before helptags can be generated.
packloadall

" Load all of the helptags now, after plugins have been loaded.
" All messages and errors will be ignored.
silent! helptags ALL
