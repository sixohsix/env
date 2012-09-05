# bash

export PS1='\u@\h:\W$ '
export REUSE_DB=1
export EDITOR=zile

_available() {
    which $1 >/dev/null 2>&1
}

_available tput && [ `tput colors` != 0 ] \
    && export CLICOLOR=1

# This loads RVM into a shell session.
#[ -s "$HOME/.rvm/scripts/rvm" ] && . "$HOME/.rvm/scripts/rvm"

[ -d /opt/ghc/bin ] && PATH=/opt/ghc/bin:$PATH
[ -d $HOME/Library/Haskell/bin ] && PATH=$HOME/Library/Haskell/bin:$PATH
[ -d $HOME/.cabal/bin ] && PATH=$HOME/.cabal/bin:$PATH
[ -d $HOME/bin ] && PATH=$HOME/bin:$PATH

[ -e $HOME/.pystartup ] && export PYTHONSTARTUP=$HOME/.pystartup

alias g=git
alias ll='ls -al'
alias develop='. ~/bin/develop.sh'
alias n='nosetests -vs'
alias b='behave --no-capture -t-browser'
alias ssh='TERM=xterm-color ssh'

alias jobe='ssh mike@jobe.ca -t tmux -2u attach'

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


function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/'
}

function parse_git_status {
  local SOUT=`g status  --porcelain -b 2>/dev/null`
  local AHEAD=`echo ${SOUT} | head -n 1 | sed -nre 's/^.*\[ahead (.*)\].*$/\1/p'`
  local DIRTY=""
  if [ "x$AHEAD" != "x" ]; then
    AHEAD="+${AHEAD} "
  fi
  if echo "${SOUT}" | tail -n +2 | grep -v "?" &>/dev/null; then
    DIRTY="* "
  fi
  echo "$AHEAD$DIRTY"
}

function proml {
  local        BLUE="\[\033[0;34m\]"
  local         RED="\[\033[0;31m\]"
  local   LIGHT_RED="\[\033[1;31m\]"
  local       GREEN="\[\033[0;32m\]"
  local LIGHT_GREEN="\[\033[1;32m\]"
  local       WHITE="\[\033[1;37m\]"
  local  LIGHT_GRAY="\[\033[0;37m\]"
  local     DEFAULT="\[\033[0m\]"
  local STATUS

  local out
  PS1="$GREEN\u@\h:\W$LIGHT_GRAY\$(parse_git_branch)$RED\$(parse_git_status)$DEFAULT\$ "
}

proml

GIT_COMPLETION_SCRIPT="/usr/share/git/completion/git-completion.bash"

if [ -e $GIT_COMPLETION_SCRIPT ]; then
  . $GIT_COMPLETION_SCRIPT
  __git_complete g __git_main
fi
