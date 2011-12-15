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
    && alias g=git \
    && complete -o bashdefault -o default -o nospace -F _git g 2>/dev/null

alias ll='ls -al'

_vem_activate_a() {
    if _available vem$1;
    then `vem$1 activate $2 | tail -n1`;
    else echo "No vem for Python $1" && 1
    fi
}
vem_activate2.5() {
    _vem_activate_a 2.5 $1
}
vem_activate2.7() {
    _vem_activate_a 2.7 $1
}
vem_activate3.2() {
    _vem_activate_a 3.2 $1
}

_project_and_branch() {
    _proj=`pwd | awk -F / '{print $NF}'`
    _branch=""
    [ -d .hg ] && _branch=`hg branch`
    [ -d .git ] && _branch=`git branch | grep '*' | cut -d ' ' -f 2`
    echo "${_proj}_${_branch}"
}

_vemac() {
    deactivate 2>/dev/null
    pb=`_project_and_branch`
    eval "vem_activate$1 $pb || vemfresh$1"
}
_vemfresh() {
    deactivate 2>/dev/null
    pb=`_project_and_branch`
    eval "vem$1 recreate $pb"
    eval "vem_activate$1 $pb && python setup.py develop"
}
vemac2.7() {
    _vemac 2.7
}
vemfresh2.7() {
    _vemfresh 2.7
}
vemac3.2() {
    _vemac 3.2
}
vemfresh3.2() {
    _vemfresh 3.2
}

# This loads RVM into a shell session.
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

export PATH=~/bin:$PATH

[ -e .pystartup ] && export PYTHONSTARTUP=~/.pystartup
