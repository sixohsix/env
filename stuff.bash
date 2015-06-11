# bash

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

# Add GHC 7.8.3 to the PATH, via http://ghcformacosx.github.io/
export GHC_DOT_APP="/Applications/ghc-7.8.3.app"
if [ -d "$GHC_DOT_APP" ]; then
    export PATH="${HOME}/.cabal/bin:${HOME}/Library/Haskell/bin:${GHC_DOT_APP}/Contents/bin:${PATH}"
else
    [ -d /opt/ghc/bin ] && PATH=/opt/ghc/bin:$PATH
    [ -d $HOME/Library/Haskell/bin ] && PATH=$HOME/Library/Haskell/bin:$PATH
    [ -d $HOME/.cabal/bin ] && PATH=$HOME/.cabal/bin:$PATH
fi

[ -d $HOME/bin ] && PATH=$HOME/bin:$PATH
[ -d /c/Python27 ] && PATH=$PATH:/c/Python27

[ -e $HOME/.pystartup ] && export PYTHONSTARTUP=$HOME/.pystartup

[ -d $HOME/node_modules/.bin ] && PATH=$HOME/node_modules/.bin:$PATH

_LOCALE=en_US.UTF-8

if _available locale && [ $(locale -a | grep $_LOCALE) ]; then
  export LC_ALL=$_LOCALE
  export LANG=$_LOCALE
fi

alias g=git
alias ll='ls -al'
alias develop='. ~/bin/develop.sh'
alias n='nosetests -vs --nologcapture'
alias dn='python abl/web/manage.py test -s'
#alias ssh='TERM=xterm-color ssh'

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

_available virtualenvwrapper.sh && use_python 2.7

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

if [ `uname` = "Darwin" ]; then
  proml
fi

GIT_COMPLETION_SCRIPT="~/.git-completion.bash"

if [ -e $GIT_COMPLETION_SCRIPT ]; then
  . $GIT_COMPLETION_SCRIPT
  __git_complete g __git_main
fi

if [ -e /Volumes/GuiEnv_64/ ]; then
  . /Volumes/GuiEnv_64/setup_qt_env.sh
fi

if [ -e /c/GuiEnv_64/ ]; then
  . /c/GuiEnv_64/setup_qt_env.sh
fi

if [ -e /c/Ruby21-x64/bin/ ]; then
  PATH=$PATH:/c/Ruby21-x64/bin
fi

_available ninja && NINJA="--ninja"
_available ccache && CCACHE="--ccache"
