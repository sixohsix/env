# bash

export PS1='\u@\h:\W$ '

_available() {
    which $1 >/dev/null 2>&1
}

_available tput && [ `tput colors` != 0 ] \
    && export CLICOLOR=1

_available zile \
    && export EDITOR=zile

[ -f git-completion.bash ] \
    && . git-completion.bash \
    && alias g=git \
    && complete -o bashdefault -o default -o nospace -F _git g 2>/dev/null

_available pip \
    && _pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
} \
    && complete -o default -F _pip_completion pip

alias ll='ls -al'

_available vem_python2.5 \
    && vem_activate25() {
    `vem_python2.5 activate $1 | tail -n1`
}
_available vem_python2.7 \
    && vem_activate27() {
    `vem_python2.7 activate $1 | tail -n1`
}
_available vem_python3.2 \
    && vem_activate32() {
    `vem_python3.2 activate $1 | tail -n1`
}

# This loads RVM into a shell session.
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

[ -d ~/bin ] \
    && export PATH=~/bin:$PATH
