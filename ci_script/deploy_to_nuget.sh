#!/bin/sh
set -e
FEED_NAME="UE4Editor-HorizonPlugin"
ONLINE_FEED_NAME="//hsgame/azure-devops/${FEED_NAME}"
nuget sources remove -name ${ONLINE_FEED_NAME}
cmd=" \
nuget sources Add -Name ${ONLINE_FEED_NAME} -Source https://pkgs.dev.azure.com/hsgame/_packaging/${FEED_NAME}/nuget/v3/index.json \
"

echo ${cmd}
eval ${cmd}


LOCAL_FEED_NAME="//hsgame/local/${FEED_NAME}"
cmd=" \
nuget sources Add -Name ${LOCAL_FEED_NAME} -Source //hsgame/package/nuget/${FEED_NAME}/ \
"

echo ${cmd}
eval ${cmd}


pushd "../"

	PACKAGE_NAME="UE4Editor-HorizonUIPluginDemo"
	rm -rf *.nupkg
	cmd=" \
	nuget pack nuspec/win64/${PACKAGE_NAME}.nuspec \
	"

	echo ${cmd}
	eval ${cmd} 
	NUPKG_FILE_NAME=$(find *.nupkg)
	NUPKG_NAME=${NUPKG_FILE_NAME%.*}



	cmd=" \
	nuget push -Source ${ONLINE_FEED_NAME} -ApiKey VSTS ${NUPKG_NAME}.nupkg \
	"

	echo ${cmd}
	eval ${cmd}

	cmd=" \
	nuget push -Source ${LOCAL_FEED_NAME} -ApiKey VSTS ${NUPKG_NAME}.nupkg \
	"

	echo ${cmd}
	eval ${cmd}
popd #../