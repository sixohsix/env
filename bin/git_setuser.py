#!/usr/bin/env python2

"""\
USAGE
  git_setuser.py <work|home>
"""

userdata = dict(
    home="""\
[user]
	name = Mike Verdone
	email = mike.verdone@gmail.com
""",
    work="""\
[user]
	name = miv
	email = mike.verdone@ableton.com
""",
    )

import sys

if __name__=='__main__':
    args = sys.argv[1:]
    if not args:
        print(__doc__)
        ret = 1
    else:
        open(".git/config", "a").write(userdata[args[0]])
        ret = 0
    sys.exit(ret)
