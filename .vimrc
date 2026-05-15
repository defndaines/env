" Key plugins: ALE (linting/fixing), vim-lsp (Elixir via expert), fzf, vim-slime, grepper.
filetype plugin indent on

" Reload vimrc immediately when saved.
autocmd! bufwritepost .vimrc source ~/.vimrc

let g:mapleader=','


""" Core Settings

set encoding=utf-8
set spelllang=en_us,cjk
set fileformat=unix
set background=light
set history=500
set nobackup
set clipboard=unnamed
set sessionoptions=blank,buffers,curdir,help,resize,tabpages,winsize


""" Display

syntax on
set number
set ruler
set showcmd
set showmode
set colorcolumn=98
highlight ColorColumn ctermbg=7 guifg=black
set display+=lastline
set scrolloff=2
set sidescrolloff=10
set wrap
set linebreak


""" Indentation

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smarttab
set autoindent " Copy indent from the previous row
set smartindent


""" Search

" Search down into subdirectories
set path+=**

set hlsearch
noremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>
set incsearch
set showmatch
set ignorecase
set smartcase
set visualbell t_vb=


""" Completion

set backspace=indent,eol,start
set complete-=i
set complete+=kspell
set completeopt=menuone,preview

" Use j and k to navigate pop-up (omnicomplete).
inoremap <expr> j ((pumvisible())?("\<C-n>"):("j"))
inoremap <expr> k ((pumvisible())?("\<C-p>"):("k"))


""" Editor Behavior

" Don’t redraw screen during macro execution (makes them faster)
set lazyredraw

set wildmenu
set wildmode=list:longest
set wildignore+=*DS_Store*
set wildignore+=*.so,*.swp,*.beam

set ttimeout
set ttimeoutlen=100

set hidden

" Use <F2> to toggle paste mode
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>

" Persistent Undo across sessions
set undofile
set undodir=$VIMDATA/undo
call mkdir(&undodir, 'p')
augroup vimrc
  autocmd!
  autocmd BufWritePre */tmp/* setlocal noundofile
augroup END

" Causes % to navigate XML tags.
runtime macros/matchit.vim

" Request terminal version string (for xterm)
set t_RV=

" Do not display banner in Netrw (file browsing).
" See netrw-browse-maps for more info.
let g:netrw_banner=0

" Avoid bogging down start-up on large files.
autocmd BufReadPre * if getfsize(expand("%")) > 1000000 | let b:enable_spelunker_vim = 0 | endif

augroup all-files
  autocmd!
  " Turn off auto-commenting
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

  " When editing a file, always jump to the last known cursor position.
  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \   exe "normal! g`\"" |
        \ endif
augroup END


""" Mappings

nnoremap <leader>n :set invnumber<CR>
nnoremap <leader>s :set spell!<CR>

" Move up or down in column to next non-blank line.
nnoremap g<up> ?\%<C-R>=virtcol(".")<CR>v\S<CR>
nnoremap g<down> /\%<C-R>=virtcol(".")<CR>v\S<CR>

" Uppercase previously typed word and continue on.
inoremap <c-u> <esc>viwUea

" Handle my common command typos.
cnoreabbrev <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
cnoreabbrev <expr> e3 ((getcmdtype() is# ':' && getcmdline() is# 'e3')?('e#'):('e3'))

" Force save when using a read-only file
cnoremap sudow w !sudo dd of=%

" Strip all trailing whitespace, but doesn't include MSWin Returns
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" Strip double-spaces (like from a formatted paste)
nnoremap <leader>p :%s/\(\S \) \+/\1/g<CR>


""" Utilities

" Sort a comma-separated selection
xnoremap s s<c-r>=join(sort(split(@", '\s*,\s*')), ', ')<cr><esc>

" Visual star search: make *|# act upon the current visual selection.
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

" Open URL
vnoremap <leader>o y:silent exec "!open ". shellescape(@", 1)<CR>:redraw!<CR>

" Format XML
command! FormatXML :%!python3 -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"
nnoremap <leader>x :FormatXML<CR>

" Format JSON
nnoremap <leader>j :%!python3 -m json.tool<CR>1G=G:call FormatJSON()<CR>
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
endfunction

" Insert the current date
nnoremap <leader>d "=strftime("%Y-%m-%d")<CR>p


" Apply title_case() to the visual selection
function! s:TitleCase()
  let [_, lnum1, col1, _] = getpos("'<")
  let [_, lnum2, col2, _] = getpos("'>")
  if lnum1 != lnum2 | return | endif
  let line = getline(lnum1)
  let selected = strpart(line, col1 - 1, col2 - col1 + 1)
  let processed = substitute(system(expand('~/.vim/bin/title_case'), selected), '\n$', '', '')
  call setline(lnum1, strpart(line, 0, col1 - 1) . processed . strpart(line, col2))
endfunction
xnoremap <leader>t :<C-u>call <SID>TitleCase()<CR>

" Wrap selection with quotation marks or markdown emphasis.
vnoremap <leader>" <esc>`>a"<esc>`<i"<esc>
vnoremap <leader>' <esc>`>a'<esc>`<i'<esc>
vnoremap <leader>` <esc>`>a`<esc>`<i`<esc>
nnoremap <leader>" viw<esc>`>a"<esc>`<i"<esc>
nnoremap <leader>' viw<esc>`>a'<esc>`<i'<esc>
nnoremap <leader>` viw<esc>`>a`<esc>`<i`<esc>
vnoremap <leader>i <esc>`>a*<esc>`<i*<esc>
vnoremap <leader>b <esc>`>a**<esc>`<i**<esc>

iabbrev teh the
iabbrev fo of
iabbrev funciton function


""" Language: Git

augroup git
  autocmd!
  autocmd FileType gitcommit setlocal spell textwidth=72
augroup END


""" Language: Erlang

augroup erlang
  autocmd!
  autocmd BufRead,BufNewFile *.erl,*.es,*.hrl,*.yaws,*.xrl setlocal expandtab
  autocmd BufNewFile,BufRead *.erl,*.es,*.hrl,*.yaws,*.xrl setf erlang

  " Highlight when a comma is not followed by a space.
  autocmd FileType erlang match SyntaxHighlight /,[ \n]\@!/

  " Highlight when a pipe is not surrounded by spaces.
  " autocmd FileType erlang match SyntaxHighlight /[ |]\@!|[ |]\@!/
augroup END

highlight SyntaxHighlight ctermbg=darkblue guibg=darkblue


""" Language: Elixir

augroup elixir
  autocmd!
  autocmd FileType elixir setlocal textwidth=98
augroup END

nnoremap <leader>z :call OpenElixirTestFile()<CR>

function! OpenElixirTestFile()
  let s:ns = fnamemodify(expand('%'), ':r:s#lib#test#') . '_test.exs'
  execute "edit " . s:ns
endfunction

" Collapse a multi-line def/if block to a single-line keyword form.
function! s:CollapseElixirBlock()
  let def_lnum = search('^\s*\(def\|defp\|if\)\s\+.\{-}\s\+do\s*$', 'bcnW')
  if def_lnum == 0
    return
  endif

  let indent = matchstr(getline(def_lnum), '^\s*')
  let end_lnum = -1
  for lnum in range(def_lnum + 1, line('$'))
    if getline(lnum) =~# '^\s*end\s*$' && matchstr(getline(lnum), '^\s*') ==# indent
      let end_lnum = lnum
      break
    endif
  endfor

  if end_lnum == -1
    return
  endif

  let body = join(map(getline(def_lnum + 1, end_lnum - 1), 'trim(v:val)'), ' ')
  let def_text = substitute(getline(def_lnum), '\s\+do\s*$', '', '')

  call setline(def_lnum, def_text . ', do: ' . body)
  silent execute (def_lnum + 1) . ',' . end_lnum . 'delete _'
endfunction

nnoremap <leader>c :<C-u>call <SID>CollapseElixirBlock()<CR>


""" Language: Python

augroup python
  autocmd!
  autocmd FileType python setlocal textwidth=88 shiftwidth=4 tabstop=4 softtabstop=4 colorcolumn=88
augroup END


""" Language: Lua

augroup lua
  autocmd!
  " like StyLua
  autocmd BufNewFile,BufRead *.lua setlocal noexpandtab tabstop=4 softtabstop=4 shiftwidth=4
augroup END


""" Language: Text and Markdown

augroup text
  autocmd!
  autocmd FileType text setlocal nosmartindent
  autocmd FileType text setlocal spl=en_us spell
  " Force markdown over modula2
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd FileType markdown setlocal spell
  autocmd BufRead,BufNewFile *.md setlocal textwidth=78
augroup END

let g:markdown_fenced_languages = ['bash', 'shell=bash', 'sql', 'html', 'css', 'javascript', 'js=javascript', 'json=javascript', 'erlang', 'vim', 'xml', 'yaml']


""" Language: HTML

augroup html
  autocmd!
  autocmd BufNewFile *.html source ~/.vim/ftplugin/htmltemplate.vim
augroup END


""" Language: VimL / Exercism

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


""" Plugin: vim-slime

let g:slime_target = 'tmux'
let g:slime_paste_file = expand("$HOME/.slime_paste")
" This allows slime to work with tmate!
let g:slime_default_config = {"socket_name": get(split($TMUX, ","), 0), "target_pane": ":.1"}


""" Plugin: NERDcommenter

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
let g:NERDDefaultAlign = 'left'


""" Plugin: fzf

nnoremap <C-p> :<C-u>FZF<CR>


""" Plugin: Grepper

let g:grepper = {}
let g:grepper.tools = ['rg']

" Search for the current word.
nnoremap <leader>* :Grepper -cword -noprompt<CR>

" Search for the current selection.
nmap gs <plug>(GrepperOperator)
xmap gs <plug>(GrepperOperator)


""" Plugin: vim-lsp

function! s:FindElixirRoot(server_info) abort
  let l:mix_dir = lsp#utils#find_nearest_parent_file_directory(
        \ lsp#utils#get_buffer_path(), 'mix.exs')
  let l:grandparent = fnamemodify(l:mix_dir, ':h:h')
  if filereadable(l:grandparent . '/mix.exs')
    return lsp#utils#path_to_uri(l:grandparent)
  endif
  let l:parent = fnamemodify(l:mix_dir, ':h')
  if filereadable(l:parent . '/mix.exs')
    return lsp#utils#path_to_uri(l:parent)
  endif
  return lsp#utils#path_to_uri(l:mix_dir)
endfunction

augroup vim_lsp_servers
  autocmd!
  autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'expert',
        \ 'cmd': {_ -> ['/opt/homebrew/bin/expert', '--stdio']},
        \ 'allowlist': ['elixir'],
        \ 'root_uri': function('s:FindElixirRoot'),
        \})
augroup END

noremap <leader>ad :LspDefinition<CR>
noremap <leader>ar :LspReferences<CR>
noremap <leader>aa :LspCodeAction<CR>
nnoremap <leader>K :LspHover<CR>


""" Plugin: ALE

" Enable completion where available.
let g:ale_completion_enabled = 1

" Navigate to ALE errors.
nmap <silent> <C-k> <Plug>(ale_previous)
nmap <silent> <C-j> <Plug>(ale_next)

" Only lint on save.
let g:ale_lint_on_text_changed = 'never'

let g:ale_linters = {
      \ 'elixir': ['credo', 'expert'],
      \ 'rust': ['rust-analyzer'],
      \ 'lua': ['luac', 'luacheck'],
      \ 'python': ['ruff'],
      \}

let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'elixir': ['mix_format'],
      \ 'javascript': ['prettier', 'eslint'],
      \ 'rust': ['rustfmt'],
      \ 'lua': ['stylua'],
      \ 'python': ['ruff'],
      \}

let g:ale_elixir_credo_strict = 1
let g:ale_elixir_expert_executable = '/opt/homebrew/bin/expert'

let g:ale_sign_error = '✘'
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1

nnoremap <leader>af :ALEFix<CR>
