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
    -OutputDirectory ${OUTPUT_DIRECTORY} -PackageSaveMode nuspec \
    -Source ${FEED_NAME} \
    -ExcludeVersion -ForceEnglishOutput  \
    "
#-Verbosity detailed
echo ${cmd}
eval ${cmd} 