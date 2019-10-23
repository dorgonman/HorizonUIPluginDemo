#!/bin/bash
set -e
basePath=$(cd "$(dirname "$0")"; pwd)
projectRoot=$(cd "${basePath}/../"; pwd)
pushd ..
    projectFileName=$(find *.uproject)
    projectName=${projectFileName%.*}

    NUGET=${projectRoot}/ue_ci_scripts/bin/Win64/nuget/nuget
    if [ ! -f "$NUGET" ]
    then
        NUGET=nuget
    fi
popd
packageName=${projectName}


outputDirectory="../Intermediate/NuGetCache/"
mkdir -p ${outputDirectory}
outputDirectory=$(cd ${outputDirectory};pwd)


echo outputDirectory: ${outputDirectory}
echo packageName: ${packageName}
echo FEED_NAME: ${FEED_NAME}
pushd ${projectRoot}
    git fetch --prune --tags origin
	git describe --tags --abbrev=0 --match=editor/* 
	packageVersion=$(git describe --tags --abbrev=0 --match=editor/*  | grep -a "editor" | grep -Eo '[.0-9]*{1,9}') || true
popd


if [ -n "${packageVersion}" ]; then
    installVersion="-Version ${packageVersion}"
else
    echo "[Info] can't find packageVersion, will install latest"
    installVersion=' '
fi

cmd=" \
    ${NUGET} install ${packageName} ${installVersion} \
    -OutputDirectory ${outputDirectory} -PackageSaveMode nuspec \
    -Source ${FEED_NAME} \
    -ForceEnglishOutput  \
    "
#-ExcludeVersion -Verbosity detailed
echo ${cmd}
eval ${cmd} 


if [ "${installVersion}" != ' ' ]; then
    nugetFolder=../Intermediate/NugetCache/${packageName}.${packageVersion}
    
    echo "Using current nuget pacakge from cache:"
else
    nugetFolder=$(ls -d -- ../Intermediate/NugetCache/* | tail -n 1)
    echo "Using latest nuget pacakge from cache:"
fi

nugetFolder=$(cd ${nugetFolder}; pwd)
echo "${nugetFolder}"
cmd="cp -rf ${nugetFolder}/* ${projectRoot}"
echo ${cmd}
eval ${cmd}