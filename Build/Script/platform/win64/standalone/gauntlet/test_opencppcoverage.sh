#!/usr/bin/env bash
# Build/Script/platform/win64/standalone/gauntlet/test_opencppcoverage.sh
# Local override for gauntlet test execution with OpenCppCoverage.
# Delegates to Build/Base/.../gauntlet/test_opencppcoverage.sh
# then copies ctest-report.xml to the path expected by unrealTest.groovy:
#   ${KANO_TEST_XML:-Reports/tests/${slug}/tests.xml}

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# From Build/Script/platform/win64/standalone/gauntlet/, go up 6 levels to project root,
# then down to Build/Base/Script/...
source "${SCRIPT_DIR}/../../../../../Base/Script/platform/win64/standalone/gauntlet/test_opencppcoverage.sh"

# Copy Unreal's automation report to the JUnit path expected by unrealTest.groovy.
_report_dir="$(build_test_result_report_directory)"
_dest_dir="${KANO_TEST_REPORT_DIR:-Reports/tests/${PROJECT_NAME:-HorizonUIPluginDemo}}"
mkdir -p "${_dest_dir}"
if [[ -f "${_report_dir}/ctest-report.xml" ]]; then
    cp -f "${_report_dir}/ctest-report.xml" "${_dest_dir}/tests.xml"
elif [[ -f "${_report_dir}/index.json" ]]; then
    _project_root="${PROJECT_ROOT:-$(build_project_root)}"
    _converter="${_project_root}/Build/Base/Script/tools/unreal_json_to_ctest.py"

    if [[ ! -f "${_converter}" ]]; then
        echo "ERROR: unreal_json_to_ctest.py not found at ${_converter}" >&2
        exit 2
    fi

    _python="$(build_python_command)"
    "${_python}" "${_converter}" --from-path "${_report_dir}/index.json" --to-path "${_dest_dir}/tests.xml"
fi

# Copy OpenCppCoverage output to the Cobertura path expected by unrealTest.groovy.
_coverage_src="$(build_test_coverage_report_directory)/${PROJECT_NAME:-HorizonUIPluginDemo}Test/cobertura.xml"
_coverage_dest="${KANO_COVERAGE_XML:-Reports/coverage/${PROJECT_NAME:-HorizonUIPluginDemo}/cobertura.xml}"
if [[ -f "${_coverage_src}" ]]; then
    _coverage_src_norm="$(printf '%s' "${_coverage_src}" | tr '\\' '/')"
    _coverage_dest_norm="$(printf '%s' "${_coverage_dest}" | tr '\\' '/')"
    if [[ "${_coverage_src_norm}" != "${_coverage_dest_norm}" ]]; then
        mkdir -p "$(dirname "${_coverage_dest}")"
        cp -f "${_coverage_src}" "${_coverage_dest}"
    fi
fi
