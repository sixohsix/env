# bash

export PS1='\u@\h:\W$ '

_available() {
    which $1 >/dev/null 2>&1
}

_available tput && [ `tput colors` != 0 ] \
    && export CLICOLOR=1

export EDITOR=zile

[ -f git-completion.bash ] \
    && . git-completion.bash \
    && complete -o bashdefault -o default -o nospace -F _git g 2>/dev/null

# This loads RVM into a shell session.
[ -s "$HOME/.rvm/scripts/rvm" ] && . "$HOME/.rvm/scripts/rvm"

[ -d /opt/ghc/bin ] && PATH=/opt/ghc/bin:$PATH
[ -d $HOME/.cabal/bin ] && PATH=$HOME/.cabal/bin:$PATH
[ -d $HOME/bin ] && PATH=$HOME/bin:$PATH

[ -e $HOME/.pystartup ] && export PYTHONSTARTUP=$HOME/.pystartup

alias g=git
alias ll='ls -al'
alias develop='. ~/bin/develop.sh'
alias n='nosetests -vs'
alias ssh='TERM=xterm-color ssh'

gco() {
  git checkout $@
  develop
}

if which virtualenvwrapper.sh 2>&1 >/dev/null
then
    WORKON_HOME="$HOME/.venvs2.7"
    VIRTUALENVWRAPPER_PYTHON=`which python2.7`
    . `which virtualenvwrapper.sh`
fi
