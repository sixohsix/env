# bash

export PS1='\u@\h:\W$ '
export REUSE_DB=1
export EDITOR=zile

if [ `uname` == "Darwin" ]; then
  SED='sed -E'
else
  SED='sed -r'
fi

_available() {
    which $1 >/dev/null 2>&1
}

_available tput && [ `tput colors` != 0 ] \
    && export CLICOLOR=1

[ -d /opt/ghc/bin ] && PATH=/opt/ghc/bin:$PATH
[ -d $HOME/Library/Haskell/bin ] && PATH=$HOME/Library/Haskell/bin:$PATH
[ -d $HOME/.cabal/bin ] && PATH=$HOME/.cabal/bin:$PATH
[ -d $HOME/bin ] && PATH=$HOME/bin:$PATH
[ -d /usr/local/opt/ruby/bin/ ] && PATH=/usr/local/opt/ruby/bin/:$PATH

[ -e $HOME/.pystartup ] && export PYTHONSTARTUP=$HOME/.pystartup

_LOCALE=en_CA.UTF-8

if [ $(locale -a | grep $_LOCALE) ]; then
  export LC_ALL=$_LOCALE
  export LANG=$_LOCALE
fi

alias g=git
alias ll='ls -al'
alias develop='. ~/bin/develop.sh'
alias n='nosetests -vs --nologcapture'
alias dn='python abl/web/manage.py test -s'
alias ssh='TERM=xterm-color ssh'

#alias jobe='ssh mike@jobe.ca -t tmux -2u attach'
alias jobe='mosh mike@jobe.ca -- tmux -2u attach'
alias jobe-tunnel='ssh -D 9090 mike@jobe.ca'
alias arc2='ssh mike@176.58.123.152 -t tmux -2u attach'
alias use_python=". ~/bin/use_python.sh"

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
  if [ ! -d .git ]; then return; fi

  local AHEAD=`git status -sb | head -n 1 | $SED -ne 's/^.*\[ahead (.*)\].*$/\1/p'`
  local DIRTY=""
  if [ "x$AHEAD" != "x" ]; then
    AHEAD="+${AHEAD} "
  fi
  if git status -sb | tail -n +2 | grep -v '?' &>/dev/null; then
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

GIT_COMPLETION_SCRIPT="/usr/share/git-core/git-completion.bash"

if [ -e $GIT_COMPLETION_SCRIPT ]; then
  . $GIT_COMPLETION_SCRIPT
  __git_complete g __git_main
fi
