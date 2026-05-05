#!/usr/bin/env bash
# Build/Script/platform/win64/standalone/gauntlet/test_opencppcoverage.sh
# Local override for gauntlet test execution with OpenCppCoverage.
# Delegates to Build/Base/.../gauntlet/test_opencppcoverage.sh
# then writes Jenkins JUnit XML to the canonical Result/junit-report.xml path.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# From Build/Script/platform/win64/standalone/gauntlet/, go up to Build/,
# then down to Build/Base/Script/common.sh.
source "${SCRIPT_DIR}/../../../../../Base/Script/common.sh"

HOST_PLATFORM="${HOST_PLATFORM:-Win64}"
TARGET_PLATFORM="${TARGET_PLATFORM:-Win64}"
TARGET_CONFIGURATION="${TARGET_CONFIGURATION:-Development}"
KANOBUILD_GAUNTLET_BUILD_KIND="${KANOBUILD_GAUNTLET_BUILD_KIND:-Standalone}"
KANOBUILD_GAUNTLET_TEST_BUILD_PATH="${KANOBUILD_GAUNTLET_TEST_BUILD_PATH:--build=local}"
KANOBUILD_GAUNTLET_ENABLE_COVERAGE="${KANOBUILD_GAUNTLET_ENABLE_COVERAGE:-true}"

export KANOBUILD_FORCE_OPENCPPCOVERAGE="1"
export HOST_PLATFORM TARGET_PLATFORM TARGET_CONFIGURATION
export KANOBUILD_GAUNTLET_BUILD_KIND KANOBUILD_GAUNTLET_TEST_BUILD_PATH KANOBUILD_GAUNTLET_ENABLE_COVERAGE
export KANOBUILD_RENDER_REPORTS=1

build_log "Entry script: ${BASH_SOURCE[0]}"
build_log "Entry env: HOST_PLATFORM=${HOST_PLATFORM} TARGET_PLATFORM=${TARGET_PLATFORM} TARGET_CONFIGURATION=${TARGET_CONFIGURATION}"
build_log "Entry env: KANOBUILD_GAUNTLET_BUILD_KIND=${KANOBUILD_GAUNTLET_BUILD_KIND} KANOBUILD_GAUNTLET_TEST_BUILD_PATH=${KANOBUILD_GAUNTLET_TEST_BUILD_PATH} KANOBUILD_GAUNTLET_ENABLE_COVERAGE=${KANOBUILD_GAUNTLET_ENABLE_COVERAGE} KANOBUILD_FORCE_OPENCPPCOVERAGE=${KANOBUILD_FORCE_OPENCPPCOVERAGE}"

set +e
build_run_gauntlet_test "$@"
_gauntlet_status=$?
set -e

# Convert Unreal's automation report to CTest + JUnit XML.
_report_dir="$(build_test_result_report_directory)"
if [[ -f "${_report_dir}/index.json" ]]; then
    _project_root="${PROJECT_ROOT:-$(build_project_root)}"
    _converter="${_project_root}/Build/Base/Script/tools/unreal_json_to_ctest.py"

    if [[ ! -f "${_converter}" ]]; then
        echo "ERROR: unreal_json_to_ctest.py not found at ${_converter}" >&2
        exit 2
    fi

    _python="$(build_python_command)"
    "${_python}" "${_converter}" --from-path "${_report_dir}/index.json" --to-path "${_report_dir}/ctest-report.xml" --junit-to-path "${_report_dir}/junit-report.xml"
fi

exit "${_gauntlet_status}"

