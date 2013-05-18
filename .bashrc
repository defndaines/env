set -o vi
stty stop ''  # Prevent Ctrl-S from stopping the terminal.


PATH=${PATH}:${HOME}/bin
PATH=${PATH}:${HOME}/.rvm/bin # Add RVM to PATH for scripting

###
# Mac OS X stuff

PATH=${PATH}:/usr/local/mysql/bin/

# This ensures that (Exuberant) ctags takes precedence
PATH=/usr/local/bin:${PATH}

#alias words = '/usr/share/dict/words'
