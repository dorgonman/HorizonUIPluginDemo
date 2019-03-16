#!/bin/sh
set -e

export PACKAGE_NAME="MBS"
export FEED_NAME=$1
export OUTPUT_DIRECTORY=$(cd ../GameProject; pwd)
pushd ${OUTPUT_DIRECTORY}/${PACKAGE_NAME}
    git fetch --prune --tags origin
    git tag -l --points-at HEAD
    export PACKAGE_VERISON=$(git tag -l --points-at HEAD | grep -a "editor/hsgame/" | grep -Eo '[.0-9]*{1,9}')
popd


BASE_PATH=$(cd "$(dirname "$0")"; pwd)
SCRIPT_PATH=$(cd ${BASE_PATH}/../GameProject/${PACKAGE_NAME}/horizon_ci_scripts/ci_scripts/sh/nuget/; pwd)
pushd ${SCRIPT_PATH}
./install_package.sh
popd

