#!/bin/sh
set -e
git checkout -f master
git pull
git submodule foreach --recursive "git checkout -f master"
git submodule foreach --recursive "git pull"

pushd ci_scripts/nuget/

./install_package_from_hsgame-locall.sh
popd 