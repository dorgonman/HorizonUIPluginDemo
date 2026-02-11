#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# Source base common.sh first
source "${SCRIPT_DIR}/../../../Base/Script/common.sh"
# Source project common.sh second so its build_run_server override takes precedence
source "${SCRIPT_DIR}/../../common.sh"

KANOBUILD_SKIP_SUBST="${KANOBUILD_SKIP_SUBST:-}"
HOST_PLATFORM="${HOST_PLATFORM:-WIN64}"
TARGET_PLATFORM="${TARGET_PLATFORM:-WIN64}"
TARGET_CONFIGURATION="${TARGET_CONFIGURATION:-Development}"
case "$(build_requested_target_platform)" in
    WIN64|LINUX) ;;
    *)
        echo "Unsupported target for win64 server: $(build_requested_target_platform)" >&2; exit 1 ;;
esac
build_run_server "$@"
