#!/bin/bash
set -e


#!/bin/bash
set -e
export FEED_NAME="\\\\\\\\HSGAME\\\\UE4-Packaged-build\\\\nuget\\\\hsgame-local\\\\GameProject"

basePath=$(cd "$(dirname "$0")"; pwd)
export PROJECT_ROOT=$(cd "${basePath}/../"; pwd)

pushd ${PROJECT_ROOT} > /dev/null
    source ue_ci_scripts/function/sh/public/ue_deploy_function.sh
    CreateNugetGamePackage
popd > /dev/null
