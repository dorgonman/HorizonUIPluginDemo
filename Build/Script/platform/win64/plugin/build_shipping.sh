#!/usr/bin/env bash
# HorizonUIPluginDemo - Build ONLY HorizonUIPlugin (not all plugins)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Source the local override common.sh layer first.
source "${SCRIPT_DIR}/../../../../Base/Script/common.sh"

HOST_PLATFORM="${HOST_PLATFORM:-Win64}"
TARGET_PLATFORM="${TARGET_PLATFORM:-Win64}"
TARGET_CONFIGURATION="${TARGET_CONFIGURATION:-Shipping}"

# Override build_find_plugins to only return HorizonUIPlugin
build_find_plugins() {
    local project_root="${1:-$(build_project_root)}"
    # Only return HorizonUIPlugin, not all plugins in Plugins/ directory
    if [[ -f "${project_root}/Plugins/HorizonUIPlugin/HorizonUIPlugin.uplugin" ]]; then
        printf '%s\n' "${project_root}/Plugins/HorizonUIPlugin/HorizonUIPlugin.uplugin"
    else
        echo "ERROR: HorizonUIPlugin not found at ${project_root}/Plugins/HorizonUIPlugin/HorizonUIPlugin.uplugin" >&2
        return 1
    fi
}

# Now run the plugin build - it will use our overridden build_find_plugins
build_run_plugin "$@"
