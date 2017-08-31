env
===

Environmental configuration files to be shared across any machine I happen to be using.

In addition to these files, it is also recommended to install git completion:
https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash

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
* [vim-fireplace](https://github.com/tpope/vim-fireplace.git) For Clojure development leveraging nREPL integration.

Clojure
* [vim-clojure-highlight](https://github.com/guns/vim-clojure-highlight)
* [vim-clojure-static](https://github.com/guns/vim-clojure-static.git)
* [vim-fireplace](https://github.com/tpope/vim-fireplace.git)

Erlang
* [erlang-motions](https://github.com/edkolev/erlang-motions.vim.git)
* [vim-erlang-compiler](https://github.com/vim-erlang/vim-erlang-compiler.git)
* [vim-erlang-tags](https://github.com/vim-erlang/vim-erlang-tags.git)
* [vim-erlang-omnicomplete](https://github.com/vim-erlang/vim-erlang-omnicomplete.git)

Elixir
* [alchemist](https://github.com/slashmili/alchemist.vim.git)
* [phoenix](https://github.com/c-brenn/phoenix.vim.git)

Elm
* [elm-vim](https://github.com/ElmCast/elm-vim.git)

Paredit
* [paredit](https://github.com/kovisoft/paredit) For parentheses manipulation.
This required a more manual install than the other tools above.
