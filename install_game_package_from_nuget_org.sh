#!/bin/bash
set -e

pushd .nuget
    ./install_game_package_from_nuget_org.sh
popd