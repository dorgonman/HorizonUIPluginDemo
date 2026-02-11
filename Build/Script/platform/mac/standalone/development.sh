#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ "${OSTYPE:-}" == darwin* ]]; then
    source "${SCRIPT_DIR}/../../../../Base/Script/common.sh"

    HOST_PLATFORM="${HOST_PLATFORM:-Mac}"
    TARGET_PLATFORM="${TARGET_PLATFORM:-Mac}"
    TARGET_CONFIGURATION="${TARGET_CONFIGURATION:-Development}"

    build_run_standalone "$@"
else
    source "${SCRIPT_DIR}/../common.sh"
    export KANOBUILD_REMOTE_SYNC_BACK_PROFILE="BuildPackage"
    horizon_mac_remote_build "Build/Script/platform/mac/standalone/development.sh" "$@"
fi