#!/bin/sh
set -e

export UE4_ENGINE_ROOT=${UE4_ENGINE_ROOT}
export PACKAGE_NAME="UE4Editor-HorizonUIPluginDemo"
export FEED_NAME="hsgame-local"
BASE_PATH=$(cd "$(dirname "$0")"; pwd)
pushd ${BASE_PATH}
../../horizon_ci_scripts/ci_scripts/sh/nuget/install_package.sh
popd