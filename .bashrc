# Check for an interactive session
[ -z "$PS1" ] && return

# Define aliases and generic shell variables.
[[ -f ~/.pathrc ]] && . ~/.pathrc
[[ -f ~/.aliasrc ]] && . ~/.aliasrc
[[ -f ~/.envrc ]] && . ~/.envrc
[[ -f /etc/bashrc ]] && . /etc/bashrc # global definitions, if any

# loading nvm and completion
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
