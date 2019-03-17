#!/bin/bash
set -e

FEED_NAME="https://hsgame.pkgs.visualstudio.com/_packaging/MBS/nuget/v3/index.json"
./install_game_package.sh ${FEED_NAME}