#!/bin/bash
set -e


basePath=$(cd "$(dirname "$0")"; pwd)
export PROJECT_ROOT=$(cd "${basePath}/../"; pwd)

pushd ${PROJECT_ROOT} > /dev/null
    source ue_ci_scripts/function/sh/public/ue_deploy_function.sh
    CreateNugetGamePackage
	export FEED_NAME="https://nexus.horizonia.vpnplus.to/repository/nuget-hosted/"
	export NUGET_API_KEY="01b53c82-b92a-366c-b846-8a3cc10c43a501b53c82-b92a-366c-b846-8a3cc10c43a5"
	export OUTPUT_DIRECTORY="${PROJECT_ROOT}/Intermediate/LocalBuilds/ArchiveForUGS/NuGet/"
	PushNugetPackage

popd > /dev/null
