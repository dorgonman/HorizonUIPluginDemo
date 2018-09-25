#!/bin/sh
set -e
git clean -xfd
git submodule foreach --recursive "git clean -xfd"