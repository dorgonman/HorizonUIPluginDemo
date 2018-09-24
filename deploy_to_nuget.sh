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



cmd=" \
nuget pack nuspec/win64/${PACKAGE_NAME}.nuspec \
"

echo ${cmd}
#eval ${cmd} 


cmd=" \
nuget push -Source ${PACKAGE_NAME} -ApiKey VSTS ${PACKAGE_NAME}.0.0.0.nupkg \
"

echo ${cmd}
#eval ${cmd}