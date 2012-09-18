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

#alias jobe='ssh mike@jobe.ca -t tmux -2u attach'
alias jobe='mosh --server="LANG=en_US.UTF-8 mosh-server" -- mike@jobe.ca tmux -2u attach'
alias jobe-tunnel='ssh -D 9090 mike@jobe.ca'
alias arc2='ssh mike@176.58.123.152 -t tmux -2u attach'

gco() {
  if [ x"$@" != "x" ]; then
    git checkout $@
  fi
  git pull
  develop
}

if which virtualenvwrapper.sh 2>&1 >/dev/null; then
  WORKON_HOME="$HOME/.venvs2.7"
  VIRTUALENVWRAPPER_PYTHON=`which python2.7`
  . `which virtualenvwrapper.sh`
fi

if [ "$TERM" = "xterm" ]; then
  TERM="xterm-256color"
fi
