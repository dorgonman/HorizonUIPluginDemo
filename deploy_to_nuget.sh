#!/bin/sh
set -e
PACKAGE_NAME="UE4Editor-HorizonUIPluginDemo"
nuget sources remove -name ${PACKAGE_NAME}
cmd=" \
nuget sources Add
-Name ${PACKAGE_NAME} -Force \
 -Source 'https://pkgs.dev.azure.com/hsgame/_packaging/${PACKAGE_NAME}/nuget/v3/index.json' \
"

echo ${cmd}
eval ${cmd}


rm -rf *.nupkg
cmd=" \
nuget pack nuspec/win64/${PACKAGE_NAME}.nuspec \
"

echo ${cmd}
eval ${cmd} 
NUPKG_FILE_NAME=$(find *.nupkg)
NUPKG_NAME=${NUPKG_FILE_NAME%.*}
cmd=" \
nuget push -Source ${PACKAGE_NAME} -ApiKey VSTS ${NUPKG_NAME}.nupkg \
"

echo ${cmd}
eval ${cmd}