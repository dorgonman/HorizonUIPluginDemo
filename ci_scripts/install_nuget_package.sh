#!/bin/sh
set -e
<<LICENSE

LICENSE
source ~/.bash_profile

export UE4_ENGINE_ROOT=${UE4_ENGINE_ROOT}
export FEED_NAME="UE4Editor-HorizonPlugin"
export ONLINE_FEED_NAME="//hsgame/azure-devops/${FEED_NAME}"
export ONLINE_FEED_PATH="https://pkgs.dev.azure.com/hsgame/_packaging/${FEED_NAME}/nuget/v3/index.json"
export PACKAGE_NAME="UE4Editor-HorizonUIPluginDemo"
echo *************ONLINE_FEED_NAME: ${ONLINE_FEED_NAME}
echo ************ONLINE_FEED_PATH: ${ONLINE_FEED_PATH}
echo ************PACKAGE_NAME: ${PACKAGE_NAME}

BASE_PATH=$(cd "$(dirname "$0")"; pwd)
PROJECT_ROOT=$(cd "${BASE_PATH}/../"; pwd)
pushd "${PROJECT_ROOT}"

	source ue_ci_scripts/function/sh/ue_deploy_function.sh
	InstallNugetPackage

popd #pushd ${PROJECT_ROOT}
