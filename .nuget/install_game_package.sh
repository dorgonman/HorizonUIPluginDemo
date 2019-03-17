#!/bin/bash
set -e
pushd ..
    PROJECT_FILE_NAME=$(find *.uproject)
    PROJECT_NAME=${PROJECT_FILE_NAME%.*}
popd
export PACKAGE_NAME=${PROJECT_NAME}
export FEED_NAME=$1
export OUTPUT_DIRECTORY=$(cd ../../; pwd)

echo OUTPUT_DIRECTORY: ${OUTPUT_DIRECTORY}
echo PACKAGE_NAME: ${PACKAGE_NAME}
echo FEED_NAME: ${FEED_NAME}
pushd ${OUTPUT_DIRECTORY}/${PACKAGE_NAME}
    git fetch --prune --tags origin
    git tag -l --points-at HEAD
    export PACKAGE_VERISON=$(git tag -l --points-at HEAD | grep -a "editor/hsgame/" | grep -Eo '[.0-9]*{1,9}')
popd


BASE_PATH=$(cd "$(dirname "$0")"; pwd)
SCRIPT_PATH=$(cd ${BASE_PATH}/../horizon_ci_scripts/ci_scripts/sh/nuget/; pwd)
pushd ${SCRIPT_PATH}
./install_package.sh
popd

