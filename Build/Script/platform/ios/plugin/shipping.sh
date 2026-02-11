#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ "${OSTYPE:-}" == darwin* ]]; then
    source "${SCRIPT_DIR}/../../../../Base/Script/common.sh"

    HOST_PLATFORM="${HOST_PLATFORM:-Mac}"
    TARGET_PLATFORM="${TARGET_PLATFORM:-IOS}"
    TARGET_CONFIGURATION="${TARGET_CONFIGURATION:-Shipping}"

    build_run_plugin "$@"
else
    source "${SCRIPT_DIR}/../common.sh"
    export KANOBUILD_REMOTE_SYNC_BACK_PROFILE="BuildPlugin"
    horizon_ios_remote_build "Build/Script/platform/ios/plugin/shipping.sh" "$@"
fi
