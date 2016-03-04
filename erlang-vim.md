# Getting Started in Erlang with vim

This is a walk-through of setting up your vim to code in Erlang. It isn't meant
to teach you vim, but assumes it's already your editor of choice. This document
is essentially just a summary of the help guides for the plugins.

## Pathogen

I use [pathogen](https://github.com/tpope/vim-pathogen). Check out the project
README for full details, but you can install with:
```
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
```
Then you need the following in your `~/.vimrc` file:
```
execute pathogen#infect()
syntax on
filetype plugin indent on
```

## Erlang Plugins

You'll want to check out [vim-erlang](https://github.com/vim-erlang) for all
your Erlang vim needs, but if you are already on the latest vim (7.4), then I
recommend installing these four plugins:
- [vim-erlang-compiler](https://github.com/vim-erlang/vim-erlang-compiler.git)
- [vim-erlang-tags](https://github.com/vim-erlang/vim-erlang-tags.git)
- [vim-erlang-omnicomplete](https://github.com/vim-erlang/vim-erlang-omnicomplete.git)
- [erlang-motions](https://github.com/edkolev/erlang-motions.vim.git)
 
In BASH:
```
mkdir -p ~/.vim/bundle
cd ~/.vim/bundle
git clone https://github.com/vim-erlang/vim-erlang-compiler.git
git clone https://github.com/vim-erlang/vim-erlang-tags.git
git clone https://github.com/vim-erlang/vim-erlang-omnicomplete.git
git clone https://github.com/edkolev/erlang-motions.vim.git
```

You'll want to generate the help files for these. From within vim:
```
:Helptags
```

### Erlang Compiler

Whenever you save a `.erl` file, this plugin will automatically compile it and
indicate warnings along the left-hand side. If you navigate to the line with a
warning or error, you will see the problem indicated at the bottom of the
screen.

Additionally, you can build your entire project with `:make`. This should work
with erlang.mk and rebar.

One thing to note is that if you haven't built your entire project, you could
get warnings on save for unknown `behavior` declarations it doesn't know about
yet.

### Erlang Tags

This builds upon exuberant ctags to allow you to navigate your project code
(and dependencies).

To generate tags while editing, type `:ErlangTags`. This will generate a tags
file relevant to your current directory. For this reason, I always edit files
from the project root directory. For example, `vim src/proj_sup.erl` instead of
`vim proj_sup.erl`. You'll also want to add an exclusion to your `.gitignore`
for this generated file.

To navigate using the tags, use `Ctrl-]` to jump to a function definition. Then
use `Ctrl-t` to navigate back to your original location. You can navigate in and
out multiple levels, if you need to dive a few levels deep.

If you read the documentation for the project, it explains how to set up a git
hook to automatically generate the tags file on commit.

### Erlang Omnicomplete

This allows you to auto-complete function declarations. To use it while in
INSERT mode, type `Ctrl-x Ctrl-o`. This will present you with a drop-down list
of options (if there are multiple options). It includes any functions currently
in scope, as well as Erlang built-in-functions and the standard library.

*NOTE*: By default, this plugin expects you to use `Ctrl-n` and `Ctrl-p` to
navigate up and down the pop-up list. If you prefer to use `j` and `k` to
navigate, add the following to your `.vimrc` file:
```
inoremap <expr> j ((pumvisible())?("\<C-n>"):("j"))
inoremap <expr> k ((pumvisible())?("\<C-p>"):("k"))
```

### Erlang Motions

This plugin enables navigation within an Erlang source file by function. You use
the `]` and `[` keys to navigate forward and backward (respectively). Just to
cover a few, `]]` will take you to the start of the next function. `]m` will
take you to the next function clause. And, `]M` will take you to the end of a
function clause.

You can also select entire functions and clauses with commands like `vim` and
`vaM`. This can be useful for moving code around or deleting entire functions.
