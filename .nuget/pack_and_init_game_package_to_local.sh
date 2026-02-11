#!/bin/bash
set -e


basePath=$(cd "$(dirname "$0")"; pwd)
export PROJECT_ROOT=$(cd "${basePath}/../"; pwd)
export FEED_NAME="${FEED_NAME:-https://nexus.horizonia.vpnplus.to/repository/nuget-hosted/}"
export NUGET_API_KEY="${NUGET_API_KEY:-01b53c82-b92a-366c-b846-8a3cc10c43a501b53c82-b92a-366c-b846-8a3cc10c43a5}"
export OUTPUT_DIRECTORY="${OUTPUT_DIRECTORY:-${PROJECT_ROOT}/Intermediate/LocalBuilds/ArchiveForUGS/NuGet/}"
export NUGET_BIN="${NUGET_BIN:-nuget}"

projectVersion=$(python - "${PROJECT_ROOT}/Config/DefaultGame.ini" <<'PY'
import pathlib
import sys

config_path = pathlib.Path(sys.argv[1])
version = "0.0.0.0"
for line in config_path.read_text(encoding="utf-8", errors="ignore").splitlines():
    if line.startswith("ProjectVersion="):
        version = line.split("=", 1)[1].strip()
        break
print(version)
PY
)

mkdir -p "${OUTPUT_DIRECTORY}"

pushd "${PROJECT_ROOT}" > /dev/null
    nuspec_path=".nuget/$(basename "${PROJECT_ROOT}").nuspec"
    "${NUGET_BIN}" pack "${nuspec_path}" \
        -BasePath "${PROJECT_ROOT}" \
        -OutputDirectory "${OUTPUT_DIRECTORY}" \
        -Version "${projectVersion}" \
        -ForceEnglishOutput \
        -Properties NoWarn=NU5104
    "${NUGET_BIN}" push "${OUTPUT_DIRECTORY}/$(basename "${PROJECT_ROOT}").${projectVersion}.nupkg" \
        -Source "${FEED_NAME}" \
        -ApiKey "${NUGET_API_KEY}" \
        -NonInteractive
popd > /dev/null
