#!/bin/bash
set -e

export FEED_NAME="//HSGAME/UE4-Packaged-build/nuget/hsgame-local/HorizonPlugin/"
./install_game_package.sh ${FEED_NAME}