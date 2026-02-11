#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../../../../../.." && pwd -P)"  # 6 levels up → repo root
BUILD_SCRIPT_ROOT="${REPO_ROOT}/Build"
BASE_SCRIPT_ROOT="${BUILD_SCRIPT_ROOT}/Base/Script"

export WORKSPACE_ROOT_DIR="${REPO_ROOT}"

if [[ "${OSTYPE:-}" == darwin* ]]; then
    if [[ -f "${BUILD_SCRIPT_ROOT}/common.sh" ]]; then
        source "${BUILD_SCRIPT_ROOT}/common.sh"
    fi

    source "${BASE_SCRIPT_ROOT}/platform/mac/editor/ugs/stage.sh"
else
    source "${SCRIPT_DIR}/../../common.sh"
    export KANOBUILD_REMOTE_SYNC_BACK_PROFILE="BuildUGS"
    horizon_mac_remote_build "Build/Script/platform/mac/editor/ugs/stage.sh" "$@"
fi