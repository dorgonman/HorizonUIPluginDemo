#!/bin/sh
set -e



FEED_NAME="UE4Editor-HorizonPlugin"
ONLINE_FEED_NAME="//hsgame/azure-devops/${FEED_NAME}"
nuget sources remove -name ${ONLINE_FEED_NAME} || true
cmd=" \
nuget sources Add -Name ${ONLINE_FEED_NAME} -Source https://pkgs.dev.azure.com/hsgame/_packaging/${FEED_NAME}/nuget/v3/index.json \
"

echo ${cmd}
eval ${cmd}


BASE_PATH=$(cd "$(dirname "$0")"; pwd)
PROJECT_ROOT=$(cd "${BASE_PATH}/../"; pwd)
OUTPUT_DIRECTORY="${PROJECT_ROOT}/Intermediate/nuget/"
mkdir -p ${OUTPUT_DIRECTORY}


pushd "${PROJECT_ROOT}"
	#source ${PROJECT_ROOT}/ue_ci_scripts/function/sh/ue_common_include.sh
	PACKAGE_NAME="UE4Editor-HorizonUIPluginDemo"

	cmd=" \
	nuget install ${PACKAGE_NAME} \
	-OutputDirectory ${OUTPUT_DIRECTORY} \
	-Source ${ONLINE_FEED_NAME} \
	-ExcludeVersion \
	"

	echo ${cmd}
	eval ${cmd} 


	cp -rf ${OUTPUT_DIRECTORY}/${PACKAGE_NAME}/* ${PROJECT_ROOT}
popd #../