#!/bin/bash
set -e
pushd ..
    PROJECT_FILE_NAME=$(find *.uproject)
    PROJECT_NAME=${PROJECT_FILE_NAME%.*}
popd
export PACKAGE_NAME=${PROJECT_NAME}
export FEED_NAME=$1
export OUTPUT_DIRECTORY=$(cd ../; pwd)
export CACHE_DIRECTORY=../Intermediate/NuGetCache/
mkdir -p ${CACHE_DIRECTORY}
CACHE_DIRECTORY=$(cd ../Intermediate/NuGetCache/;pwd)

echo OUTPUT_DIRECTORY: ${OUTPUT_DIRECTORY}
echo CACHE_DIRECTORY: ${CACHE_DIRECTORY}
echo PACKAGE_NAME: ${PACKAGE_NAME}
echo FEED_NAME: ${FEED_NAME}
pushd .. > /dev/null
    git fetch --prune --tags origin
    git tag -l --points-at HEAD
    export PACKAGE_VERISON=$(git tag -l --points-at HEAD | grep -a "editor/hsgame/" | grep -Eo '[.0-9]*{1,9}')
popd > /dev/null


if [ -n "${PACKAGE_VERISON}" ]; then
    INSTALL_VERSION="-Version ${PACKAGE_VERISON}"
else
    INSTALL_VERSION=' '
    # echo "[Error] Can't find nuget version tag here:"
    # echo "[Error] ${OUTPUT_DIRECTORY}/${PACKAGE_NAME}"
    # pushd ${OUTPUT_DIRECTORY}/${PACKAGE_NAME}  > /dev/null
    #     info=$(git show --oneline -s)
    #     echo "[Error] ${info}"
    # popd > /dev/null
    # exit 1 
fi

cmd=" \
    nuget install ${PACKAGE_NAME} ${INSTALL_VERSION} \
    -OutputDirectory ${CACHE_DIRECTORY} -PackageSaveMode nuspec -Force \
    -Source ${FEED_NAME} -Verbosity detailed \
     -ForceEnglishOutput  \
    "
#-ExcludeVersion
echo ${cmd}
eval ${cmd} 

if [ "${INSTALL_VERSION}" != ' ' ]; then
    nugetFolder=../Intermediate/NugetCache/${PACKAGE_NAME}.${PACKAGE_VERISON}
    
    echo "Using current nuget pacakge from cache:"
else
    nugetFolder=$(ls -td -- ../Intermediate/NugetCache/* | tail -n 1)
    echo "Using latest nuget pacakge from cache:"
fi
nugetFolder=$(cd ${nugetFolder}; pwd)
echo "${nugetFolder}"
cmd="cp -rf ${nugetFolder}/* ${OUTPUT_DIRECTORY}"
echo ${cmd}
eval ${cmd}