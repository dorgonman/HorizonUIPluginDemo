#!/bin/sh
set -e
git fetch origin
git submodule foreach --recursive "git fetch origin"
git checkout -f -B main origin/main
git submodule foreach --recursive "git checkout -f -B main origin/main"
