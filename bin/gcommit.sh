#!/bin/bash

set +H

if [ x"$@" == "x" ]; then
    git commit -ae
else
    git commit -am "$@"
fi
