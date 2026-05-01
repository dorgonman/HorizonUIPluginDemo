#!/usr/bin/env bash
# Build/Script/platform/win64/standalone/gauntlet/test_opencppcoverage.sh
# Local override for gauntlet test execution with OpenCppCoverage.
# Delegates to Build/Base/.../gauntlet/test_opencppcoverage.sh
# then writes Jenkins JUnit XML to the canonical Result/junit-report.xml path.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# From Build/Script/platform/win64/standalone/gauntlet/, go up 6 levels to project root,
# then down to Build/Base/Script/...
source "${SCRIPT_DIR}/../../../../../Base/Script/platform/win64/standalone/gauntlet/test_opencppcoverage.sh"

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

