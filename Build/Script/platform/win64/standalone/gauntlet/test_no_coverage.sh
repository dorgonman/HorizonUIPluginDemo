#!/usr/bin/env bash
# Build/Script/platform/win64/standalone/gauntlet/test_no_coverage.sh
# Local override for gauntlet test execution.
# Delegates to Build/Base/.../gauntlet/test_no_coverage.sh
# then writes Jenkins JUnit tests.xml to the path expected by unrealTest.groovy.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# From Build/Script/platform/win64/standalone/gauntlet/, go up 6 levels to project root,
# then down to Build/Base/Script/... (workspace is now Build/PackagedBuild/ which is 1 level deeper than before)
source "${SCRIPT_DIR}/../../../../../Base/Script/platform/win64/standalone/gauntlet/test_no_coverage.sh"

# Convert Unreal's automation report to the JUnit path expected by unrealTest.groovy.
_report_dir="$(build_test_result_report_directory)"
_dest_dir="${KANO_TEST_REPORT_DIR:-Reports/tests/${PROJECT_NAME:-HorizonUIPluginDemo}}"
mkdir -p "${_dest_dir}"
if [[ -f "${_report_dir}/index.json" ]]; then
    _project_root="${PROJECT_ROOT:-$(build_project_root)}"
    _converter="${_project_root}/Build/Base/Script/tools/unreal_json_to_ctest.py"

    if [[ ! -f "${_converter}" ]]; then
        echo "ERROR: unreal_json_to_ctest.py not found at ${_converter}" >&2
        exit 2
    fi

    _python="$(build_python_command)"
    "${_python}" "${_converter}" --from-path "${_report_dir}/index.json" --to-path "${_report_dir}/ctest-report.xml" --junit-to-path "${_dest_dir}/tests.xml"
fi

