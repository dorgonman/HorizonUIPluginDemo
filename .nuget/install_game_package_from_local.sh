#!/bin/bash
set -e

export FEED_NAME="https://nexus.horizonia.vpnplus.to/repository/nuget-hosted/"
./install_game_package.sh ${FEED_NAME}