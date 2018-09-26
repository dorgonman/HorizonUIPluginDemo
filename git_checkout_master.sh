#!/bin/sh
set -e
git checkout -f master
git pull
git submodule foreach --recursive "git checkout -f master"
git submodule foreach --recursive "git pull"

pushd ci_scripts

./install_nuget_package_local.sh
popd 