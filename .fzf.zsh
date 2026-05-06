# fzf (fuzzy finder) zsh integration. ACTIVELY USED. Sourced by .zshrc.
# Enables Ctrl-R (history search), Ctrl-T (file search), Alt-C (cd) key bindings.

HOMEBREW_PREFIX="$(brew --prefix)"

if [[ ! "$PATH" == *${HOMEBREW_PREFIX}/opt/fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}${HOMEBREW_PREFIX}/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "${HOMEBREW_PREFIX}/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "${HOMEBREW_PREFIX}/opt/fzf/shell/key-bindings.zsh"
