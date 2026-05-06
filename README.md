# env

Environmental configuration files to be shared across any machine I happen to
be using.

## New Machine Setup

After cloning this repo to `~/src/env`, run:

```sh
bin/init-machine
```

This sets up dotfile symlinks, installs Homebrew packages from `Brewfile`,
installs vim plugins, and configures the Terminal profile.

One manual step: copy `.gitconfig` to `~/.gitconfig` and update the email
address.

## vim

Plugins are installed automatically by `init-machine` into
`~/.vim/pack/bundle/start/`. Current plugins:

* [ale](https://github.com/dense-analysis/ale) — asynchronous lint engine
* [fzf](https://github.com/junegunn/fzf.git) and [fzf.vim](https://github.com/junegunn/fzf.vim.git) — fuzzy finder for quickly locating files
* [nerdcommenter](https://github.com/scrooloose/nerdcommenter.git) — code commenting functions
* [rainbow](https://github.com/luochen1990/rainbow.git) — rainbow parentheses
* [spelunker](https://github.com/kamykn/spelunker.vim.git) — spell checking inside code (smart about camelCase, etc.)
* [tabular](https://github.com/godlygeek/tabular.git) — auto-align text by a separator, e.g., `:Tabularize /|`
* [vim-elixir](https://github.com/elixir-editors/vim-elixir.git) — Elixir syntax and indentation
* [vim-endwise](https://github.com/tpope/vim-endwise.git) — automatically adds `end` in Elixir, etc.
* [vim-grepper](https://github.com/mhinz/vim-grepper.git) — asynchronous grep
* [vim-lsp](https://github.com/prabirshrestha/vim-lsp.git) — LSP client
* [vim-repeat](https://github.com/tpope/vim-repeat.git) — allows using `.` with plugins
* [vim-sandwich](https://github.com/machakann/vim-sandwich.git) — add/remove/replace surrounding delimiters
* [vim-slime](https://github.com/jpalardy/vim-slime.git) — inject text from one `tmux` pane to another

### Customizations

For pairing at work, add a `.vim/work.vim` with co-author abbreviations:

```vim
" Coworker Git autocorrects
iab gjane Co-authored-by: Jane Doe <jane.doe@company.com>
```
