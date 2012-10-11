# You must source this file.

if [ "$1" ]; then
  if which virtualenvwrapper.sh 2>&1 >/dev/null; then
    for x in `set 2>&1 | grep "^VIRTUALENVWRAPPER_*=*" | cut -d '=' -f 1`; do 
      unset $x
    done
    WORKON_HOME="$HOME/.venvs$1"
    VIRTUALENVWRAPPER_PYTHON=`which python$1`
    VIRTUALENVWRAPPER_VIRTUALENV=`which virtualenv-$1`
    . `which virtualenvwrapper.sh`
  fi
fi

