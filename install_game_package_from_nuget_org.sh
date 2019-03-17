#!/bin/bash
set -e

FEED_NAME="nuget.org"
pushd .nuget
    ./install_game_package.sh ${FEED_NAME}
popd