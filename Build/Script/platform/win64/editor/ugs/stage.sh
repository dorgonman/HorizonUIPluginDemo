#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_ROOT="$(cd "${SCRIPT_DIR}/../../../../.." && pwd)"          # 5 levels up → Build/
PROJECT_ROOT="$(cd "${BUILD_ROOT}/.." && pwd)"                    # repo root
WORKSPACE_ROOT="$(cd "${PROJECT_ROOT}/.." && pwd)"                # parent of repo root
BASE_SCRIPT_ROOT="${BUILD_ROOT}/Base/Script"

if command -v cygpath >/dev/null 2>&1; then
    export WORKSPACE_ROOT_DIR="$(cygpath -w "${WORKSPACE_ROOT}")"
else
    export WORKSPACE_ROOT_DIR="${WORKSPACE_ROOT}"
fi

if [[ -f "${BUILD_ROOT}/common.sh" ]]; then
    source "${BUILD_ROOT}/common.sh"
fi

source "${BASE_SCRIPT_ROOT}/platform/win64/editor/ugs/stage.sh"
