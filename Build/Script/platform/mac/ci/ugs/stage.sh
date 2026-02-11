#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../../../../../.." && pwd -P)"   # 6 levels up → repo root
BUILD_SCRIPT_ROOT="${REPO_ROOT}/Build"
BASE_SCRIPT_ROOT="${BUILD_SCRIPT_ROOT}/Base/Script"

export WORKSPACE_ROOT_DIR="${REPO_ROOT}"

if [[ -f "${BUILD_SCRIPT_ROOT}/common.sh" ]]; then
    source "${BUILD_SCRIPT_ROOT}/common.sh"
fi

source "${BASE_SCRIPT_ROOT}/platform/mac/ci/ugs/stage.sh"
