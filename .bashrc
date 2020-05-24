# Check for an interactive session
[ -z "$PS1" ] && return

# Define aliases and generic shell variables.
[[ -f ~/.pathrc ]] && . ~/.pathrc
[[ -f ~/.aliasrc ]] && . ~/.aliasrc
[[ -f ~/.envrc ]] && . ~/.envrc
[[ -f /etc/bashrc ]] && . /etc/bashrc # global definitions, if any
