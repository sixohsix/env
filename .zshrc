PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:/usr/local/bin:/usr/local/Cellar/ruby/2.0.0-p0/bin/:${PATH}"
PATH="${PATH}:/usr/local/Cellar/gettext/0.18.2/bin/"
PATH="${PATH}:/usr/local/share/npm/bin"

fpath=(~/.zsh $fpath)
autoload -U compinit
compinit

autoload -U mivstuff
mivstuff

# added by travis gem
[ -f /Users/miv/.travis/travis.sh ] && source /Users/miv/.travis/travis.sh
