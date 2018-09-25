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


# # LOCAL_FEED_NAME="//hsgame/local/${FEED_NAME}"
# # nuget sources remove -name ${LOCAL_FEED_NAME} || true
# #LOCAL_FEED_PATH="//hsgame/UE4-Packaged-build/nuget/${FEED_NAME}/"
# LOCAL_FEED_PATH='\\hsgame\UE4-Packaged-build\nuget\'${FEED_NAME}
# # mkdir -p //hsgame/UE4-Packaged-build/nuget/${FEED_NAME}/
#  cmd=" \
#  nuget sources Add -Name ${LOCAL_FEED_NAME} -Source ${LOCAL_FEED_PATH} \
#  "

#  echo ${cmd}
#  eval ${cmd}

BASE_PATH=$(cd "$(dirname "$0")"; pwd)
PROJECT_ROOT=$(cd "${BASE_PATH}/../"; pwd)
OUTPUT_DIRECTORY="${PROJECT_ROOT}/Intermediate/nuget/"
rm -rf ${OUTPUT_DIRECTORY}
mkdir -p ${OUTPUT_DIRECTORY}
PROJECT_BRANCH=$(git symbolic-ref --short HEAD)
GIT_REV_COUNT=$(git rev-list HEAD --count)
PROJECT_REVISION=${GIT_REV_COUNT}

PRJECT_VERSION=$(cat ${PROJECT_ROOT}/Config/DefaultGame.ini | grep 'ProjectVersion=' | grep -Eo '[0-9].{1,9}' )

pushd "${PROJECT_ROOT}"

	PACKAGE_NAME="UE4Editor-HorizonUIPluginDemo"
	rm -rf *.nupkg
	cmd=" \
	nuget pack ${PROJECT_ROOT}/ci_script/package/nuspec/win64/${PACKAGE_NAME}.nuspec \
	-BasePath ${PROJECT_ROOT} -OutputDirectory ${OUTPUT_DIRECTORY} -Version 0.0.0.${PROJECT_REVISION}\
	"

	echo ${cmd}
	eval ${cmd} 


	NUPKG_FILE_NAME=$(find ${OUTPUT_DIRECTORY}/*.nupkg)
	NUPKG_NAME=${NUPKG_FILE_NAME%.*}

	cmd=" \
	nuget init ${OUTPUT_DIRECTORY} '${LOCAL_FEED_PATH}' \
	"

	#echo ${cmd}
	#eval ${cmd}



	cmd=" \
	nuget push -Source ${ONLINE_FEED_NAME} -ApiKey VSTS ${NUPKG_NAME}.nupkg \
	"

	echo ${cmd}
	eval ${cmd}

	cmd=" \
	nuget push -Source ${LOCAL_FEED_NAME} -ApiKey VSTS ${NUPKG_NAME}.nupkg \
	"

	#echo ${cmd}
	#eval ${cmd}
popd #../