# env

Environmental configuration files to be shared across any machine I happen to
be using. I try to keep things happy between Linux and macos.

In addition to these files, it have also installed git completion manually
(not sure if this is still needed):
https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash


## `vim`

When setting up a new environment, add vim ephemera to the git ignore file.
The git configuration has to be set per environment, since the path should be
absolute.
```shell
echo "*.swp" >> ~/.gitignore
git config --global core.excludesfile ~/.gitignore
```

For vim, install these plugins by cloning into
`${HOME}/.vim/pack/bundle/start/`. The following are a list of vim libraries
I've used at one point or another.

* [vim-slime](https://github.com/jpalardy/vim-slime.git) Inject from one tmux
  pane to another.
* [ale](https://github.com/dense-analysis/ale) Asynchronous Lint Engine
* [tabular](https://github.com/godlygeek/tabular.git) Auto-align text,
  typically by a record separator. For example, `:Tabularize /|` aligns on
  pipe characters.
* [vim-repeat](https://github.com/tpope/vim-repeat.git) Allows using `.` with
  plugins.
* [vim-sandwich](https://github.com/machakann/vim-sandwich.git)
* [nerdcommenter](https://github.com/scrooloose/nerdcommenter.git) Code
  commenting functions.
* [vim-grepper](https://github.com/mhinz/vim-grepper.git) Grepper for
  asynchronous greps
* [rainbow](https://github.com/luochen1990/rainbow.git) For rainbow
  parentheses.
* [spelunker](https://github.com/kamykn/spelunker.vim.git) For catching
  spelling errors inside code (smart about camelCase, etc.)
* [endwise.vim](https://github.com/tpope/vim-endwise.git) For automatically
  adding `end` statements in Elixir, Ruby, etc.
* [fzf](https://github.com/junegunn/fzf.git) and
  [fzf.vim](https://github.com/junegunn/fzf.vim.git) Fuzzy finder for quickly
  locating files.

### Elixir
* [vim-elixir](https://github.com/elixir-editors/vim-elixir.git)

### Clojure
* [vim-clojure-static](https://github.com/guns/vim-clojure-static.git)
* [vim-iced](https://github.com/liquidz/vim-iced.git)
* [vim-sexp](https://github.com/guns/vim-sexp.git)

### Erlang
* [erlang-motions](https://github.com/edkolev/erlang-motions.vim.git)
* [vim-erlang-compiler](https://github.com/vim-erlang/vim-erlang-compiler.git)
* [vim-erlang-tags](https://github.com/vim-erlang/vim-erlang-tags.git)
* [vim-erlang-omnicomplete](https://github.com/vim-erlang/vim-erlang-omnicomplete.git)


### vim Colors

I've been favoring light themes for a bit now, but I keep a sparse
.`.vim/colors/` directory. Currently using
[PaperColor](https://raw.githubusercontent.com/NLKNguyen/papercolor-theme/master/colors/PaperColor.vim).

### Customizations

When we want to track pairing at work, I'll add a `.vim/work.vim` file that
looks roughly like this:
```
" Coworker Git autocorrects
iab gjane Co-authored-by: Jane Doe <jane.doe@company.com>
```


## CTags

I sometimes set up projects to use ctags.
[universal-ctags](https://github.com/universal-ctags/ctags)


## OCaml

I'm not actively developing in OCaml at the moment, but I still like to have
it set up in my environment, particularly so I can take advantage of
[patdiff](https://github.com/janestreet/patdiff). My
[.bash_profile](.bash_profile) already checks for `opam` installation (the
OCaml package manager), [.ocamlinit](.ocamlinit) is already set up, and
[.gitconfig](.gitconfig) is set up to allow `git patdiff <file>`.

```bash
brew install opam
opam init
eval `opam config env`
opam update
opam install patdiff
```
