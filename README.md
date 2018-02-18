env
===

Environmental configuration files to be shared across any machine I happen to be using.

In addition to these files, it is also recommended to install git completion:
https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash


## `vim`

For vim, install [vim-pathogen](https://github.com/tpope/vim-pathogen).
The following are a list of vim libraries to consider installing into .vim/bundle to be
picked up by pathogen.

* [rainbow_parentheses.vim](https://github.com/kien/rainbow_parentheses.vim.git)
Color nested parenthesis for easy visual matching.
* [tabular](https://github.com/godlygeek/tabular.git) Auto-align text, typically
by a record separator. For example, `:Tabularize /|` aligns on pipe characters.
* [vim-repeat](https://github.com/tpope/vim-repeat.git) Allows using `.` with
plugins.
* [vim-slime](https://github.com/jpalardy/vim-slime.git) Inject from one tmux
pane to another.
* [vim-surround](https://github.com/tpope/vim-surround.git)
* [nerdcommenter](https://github.com/scrooloose/nerdcommenter.git) Code commenting functions.

### Clojure
* [vim-clojure-highlight](https://github.com/guns/vim-clojure-highlight)
* [vim-clojure-static](https://github.com/guns/vim-clojure-static.git)
* [vim-fireplace](https://github.com/tpope/vim-fireplace.git) For Clojure development leveraging nREPL integration.

### Erlang
* [erlang-motions](https://github.com/edkolev/erlang-motions.vim.git)
* [vim-erlang-compiler](https://github.com/vim-erlang/vim-erlang-compiler.git)
* [vim-erlang-tags](https://github.com/vim-erlang/vim-erlang-tags.git)
* [vim-erlang-omnicomplete](https://github.com/vim-erlang/vim-erlang-omnicomplete.git)

### Elixir
* [alchemist](https://github.com/slashmili/alchemist.vim.git)
* [phoenix](https://github.com/c-brenn/phoenix.vim.git)

### Elm
* [elm-vim](https://github.com/ElmCast/elm-vim.git)

### Paredit
* [paredit](https://github.com/kovisoft/paredit) For parentheses manipulation.
This required a more manual install than the other tools above.


### vim Colors

I'm playing around with different color schemes lately, but here are a couple
I have put into the `.vim/colors/` directory:
* [dark_eyes](https://github.com/bf4/vim-dark_eyes)
* [iceberg](https://github.com/cocopon/iceberg)


## OCaml

I'm not actively developing in OCaml at the moment, but I still like to have
it set up in my environment, particularly so I can take advantage of
[patdiff](https://janestreet.github.io/patdiff.html). My
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
