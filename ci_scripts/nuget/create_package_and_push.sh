#!/bin/sh
set -e
<<LICENSE

LICENSE
source ~/.bash_profile

BASE_PATH=$(cd "$(dirname "$0")"; pwd)
pushd ${BASE_PATH}
export PACKAGE_NAME="UE4Editor-HorizonUIPluginDemo"
export NUSPEC_FILE_PATH="${BASE_PATH}/${PACKAGE_NAME}.nuspec"
../../horizon_ci_scripts/ci_scripts/sh/nuget/create_package_and_push.sh
popd