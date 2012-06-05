#!/bin/sh

if [ x"$@" == "x" ]; then
    git commit -ae
else
    git commit -am "$@"
fi
