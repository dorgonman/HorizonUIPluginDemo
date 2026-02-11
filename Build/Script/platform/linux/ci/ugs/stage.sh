#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_SCRIPT_ROOT="${SCRIPT_DIR}/../../../../.."   # 5 levels up → Build/
BASE_SCRIPT_ROOT="${BUILD_SCRIPT_ROOT}/Base/Script"

export WORKSPACE_ROOT_DIR="${BUILD_SCRIPT_ROOT}"

if [[ -f "${BUILD_SCRIPT_ROOT}/common.sh" ]]; then
    source "${BUILD_SCRIPT_ROOT}/common.sh"
fi

source "${BASE_SCRIPT_ROOT}/platform/linux/ci/ugs/stage.sh"
