# This file must be used with "source ./develop.sh" *from bash*. You
# cannot run it directly.

if [ -e ./scripts/develop.sh ]
then
    echo "Using ./scripts/develop.sh"
    . ./scripts/develop.sh
    return
fi

_usage() {
    echo
    echo USAGE:
    echo "  . ./scripts/develop.sh [options]"
    echo
    echo OPTIONS:
    echo "  --refresh-venv  recreate the virtualenv"
}

if ! OPTS=`getopt -n $0 -l refresh-venv,help -o '' -- "$@"`
then
    _usage
    return 1
fi

set -- $OPTS

_project_and_branch() {
    _proj=`pwd | awk -F / '{print $NF}'`
    _branch=""
    [ -d .git ] && _branch=_`git branch | grep '*' | cut -d ' ' -f 2`
    echo "${_proj}${_branch}"
}

if [[ `virtualenv --version` < "1.7" ]]
then
    ve_flags="--distribute --no-site-packages"
else
    ve_flags="--distribute"
fi

setup_args=""

while [[ -n "$@" ]]
do
    case "$1" in
        --refresh-venv)
            ve_flags=$ve_flags" --clear"
            ;;
        --help)
            _usage
            return 0
            ;;
        --)
            ;;
    esac
    shift
done

mkvirtualenv -q $ve_flags `_project_and_branch`

if [ x"$VIRTUAL_ENV" = "x" ]
then
    echo "You can only run this inside a virtual environment."
else
    if [ -e setup.py ]
    then
        pip_args=""
        if [ -e requirements.txt ]
        then pip_args="-r requirements.txt"; fi
        if [ -e dev_requirements.txt ]
        then pip_args=$pip_args" -r dev_requirements.txt"; fi

        pip-2.7 install $pip_args -e .
    else
        echo "Warning: setup.py not found."
    fi
fi
