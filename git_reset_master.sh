#!/bin/sh
set -e
git fetch origin
git submodule foreach --recursive "git fetch origin"
git checkout -f -B master origin/master
git submodule foreach --recursive "git checkout -f -B master origin/master"
