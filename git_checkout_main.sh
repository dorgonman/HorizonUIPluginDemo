#!/bin/sh
set -e
git fetch origin
git submodule foreach --recursive "git fetch origin"
git checkout -f main
git pull
git submodule foreach --recursive "git checkout -f main"
git submodule foreach --recursive "git pull"

pushd .nuget/

./install_game_package_from_local.sh
popd 