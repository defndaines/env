filetype plugin indent on

" Reload vimrc immediately when saved.
autocmd! bufwritepost .vimrc source ~/.vimrc

set encoding=utf-8
set spelllang=en_us,cjk
set fileformat=unix

set background=light
" colorscheme PaperColor

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

set backspace=indent,eol,start
set complete-=i
set complete+=kspell
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
cnoreabbrev <expr> e3 ((getcmdtype() is# ':' && getcmdline() is# 'e3')?('e#'):('e3'))

" Sort a comma-separated selection
:xnoremap s s<c-r>=join(sort(split(@", '\s*,\s*')), ', ')<cr><esc>

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

" Maintain some set-up between sessions
set sessionoptions=blank,buffers,curdir,help,resize,tabpages,winsize

" Strip all trailing whitespace, but doesn't include MSWin Returns
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" Strip double-spaces (like from a formatted paste)
nnoremap <leader>p :%s/\(\S \) \+/\1/g<CR>

set colorcolumn=98
highlight ColorColumn ctermbg=7 guifg=black

highlight rightMargin term=bold ctermfg=black guifg=brown

" Open URL
vnoremap <leader>o y:silent exec "!open ". shellescape(@", 1)<CR>:redraw!<CR>

" Format XML
command! FormatXML :%!python3 -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"
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
endfunction


" Insert the current date
nnoremap <leader>d "=strftime("%Y-%m-%d")<CR>p

" Apply title_case() from common/format.py to the visual selection
xnoremap <leader>t :!~/.vim/bin/title_case<CR>

" Force save when using a read-only file
cnoremap sudow w !sudo dd of=%

" Use j and k to navigate pop-up (omnicomplete).
inoremap <expr> j ((pumvisible())?("\<C-n>"):("j"))
inoremap <expr> k ((pumvisible())?("\<C-p>"):("k"))


let g:markdown_fenced_languages = ['bash', 'shell=bash', 'sql', 'html', 'css', 'javascript', 'js=javascript', 'json=javascript', 'clojure', 'erlang', 'ruby', 'eruby', 'erb=eruby', 'vim', 'xml', 'yaml']


""" Slime

let g:slime_target = 'tmux'
let g:slime_paste_file = expand("$HOME/.slime_paste")
" let g:slime_paste_file = tempname()
" This allows slime to work with tmate!
let g:slime_default_config = {"socket_name": get(split($TMUX, ","), 0), "target_pane": ":.1"}


""" Git options

augroup git
  autocmd!
  autocmd FileType gitcommit setlocal spell textwidth=72
augroup END


""" Erlang options.

augroup erlang
  autocmd!
  autocmd BufRead,BufNewFile *.erl,*.es,*.hrl,*.yaws,*.xrl set expandtab
  autocmd BufNewFile,BufRead *.erl,*.es,*.hrl,*.yaws,*.xrl setf erlang

  " Highlight when a comma is not followed by a space.
  autocmd FileType erlang match SyntaxHighlight /,[ \n]\@!/

  " Highlight when a pipe is not surrounded by spaces.
  " autocmd FileType erlang match SyntaxHighlight /[ |]\@!|[ |]\@!/
augroup END

highlight SyntaxHighlight ctermbg=darkblue guibg=darkblue

set wildignore+=*.so,*.swp,*.beam


"" Elixir

augroup elixir
  autocmd!
  autocmd FileType elixir setlocal textwidth=98
augroup END

nnoremap <leader>z :call OpenElixirTestFile()<CR>

function! OpenElixirTestFile()
  let s:ns = fnamemodify(expand('%'), ':r:s#lib#test#') . '_test.exs'
  execute "edit " . s:ns
endfunction


""" Python Options

augroup python
  autocmd!
  autocmd FileType python setlocal textwidth=88 shiftwidth=4 tabstop=4 softtabstop=4 colorcolumn=88
  autocmd BufWritePre *.py :%s/\s\+$//e
augroup END


""" PHP Options

augroup php
  autocmd!
  autocmd BufNewFile,BufRead *.php setlocal expandtab
  autocmd BufRead,BufNewFile *.php setlocal tabstop=4
  autocmd BufRead,BufNewFile *.php setlocal softtabstop=4
  autocmd BufRead,BufNewFile *.php setlocal shiftwidth=4
augroup END


""" Lua options.

augroup lua
  autocmd!
  " like StyLua
  autocmd BufNewFile,BufRead *.lua setlocal noexpandtab
  autocmd BufRead,BufNewFile *.lua setlocal tabstop=4
  autocmd BufRead,BufNewFile *.lua setlocal softtabstop=4
  autocmd BufRead,BufNewFile *.lua setlocal shiftwidth=4
augroup END


""" Text options

augroup text
  autocmd!
  autocmd FileType text setlocal nosmartindent
  autocmd FileType text :set spl=en_us spell
  " Force markdown over modula2
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd FileType markdown setlocal spell
  autocmd BufRead,BufNewFile *.md setlocal textwidth=78
augroup END

iabbrev teh the
iabbrev fo of
iabbrev funciton function

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


""" vim-lsp

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
        \ 'name': 'dexter',
        \ 'cmd': {_ -> ['/Users/mdaines/.local/bin/dexter', 'lsp']},
        \ 'allowlist': ['elixir'],
        \ 'root_uri': function('s:FindElixirRoot'),
        \})
augroup END

noremap <leader>ad :LspDefinition<CR>
noremap <leader>ar :LspReferences<CR>
noremap <leader>aa :LspCodeAction<CR>
nnoremap <leader>K :LspHover<CR>

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
      \ 'elixir': ['credo', 'expert', 'dexter'],
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
let g:ale_disable_lsp = 0

let g:ale_sign_error = '✘'
" let g:ale_sign_warning = '⚠'
" highlight ALEErrorSign ctermbg=NONE ctermfg=red
" highlight ALEWarningSign ctermbg=NONE ctermfg=yellow
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1

nnoremap <leader>af :ALEFix<CR>
" These are handled by vim-lsp
" noremap <leader>ad :ALEGoToDefinition<CR>
" noremap <leader>ar :ALEFindReferences<CR>
" nnoremap <leader>K :ALEHover<CR>


""" fzf (fuzzy finder)
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
