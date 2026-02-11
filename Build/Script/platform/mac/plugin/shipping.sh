#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ "${OSTYPE:-}" == darwin* ]]; then
    source "${SCRIPT_DIR}/../../../../Base/Script/common.sh"

    HOST_PLATFORM="${HOST_PLATFORM:-Mac}"
    TARGET_PLATFORM="${TARGET_PLATFORM:-Mac}"
    TARGET_CONFIGURATION="${TARGET_CONFIGURATION:-Shipping}"

    build_find_plugins() {
        local project_root="${1:-$(build_project_root)}"
        if [[ -f "${project_root}/Plugins/HorizonUIPlugin/HorizonUIPlugin.uplugin" ]]; then
            printf '%s\n' "${project_root}/Plugins/HorizonUIPlugin/HorizonUIPlugin.uplugin"
        else
            echo "ERROR: HorizonUIPlugin not found at ${project_root}/Plugins/HorizonUIPlugin/HorizonUIPlugin.uplugin" >&2
            return 1
        fi
    }

    build_run_plugin "$@"
else
    source "${SCRIPT_DIR}/../common.sh"
    export KANOBUILD_REMOTE_SYNC_BACK_PROFILE="BuildPlugin"
    horizon_mac_remote_build "Build/Script/platform/mac/plugin/shipping.sh" "$@"
fi
