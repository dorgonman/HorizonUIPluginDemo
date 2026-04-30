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
    # Converter lives under Build/Base/Script/tools/ in the Build/Base submodule.
    # The submodule's common.sh build_test_report_converter_path() still resolves
    # to the old "utilities/" path on the workspace copy. Use a direct path to
    # the actual converter in the Build/Base submodule root instead.
    _converter="${SCRIPT_DIR}/../../../../../../Base/Script/tools/unreal_json_to_ctest.py"
    _python="$(build_python_command)"
    "${_python}" "${_converter}" --from-path "${_report_dir}/index.json" --to-path "${_dest_dir}/tests.xml"
fi

# Copy OpenCppCoverage output to the Cobertura path expected by unrealTest.groovy.
_coverage_src="$(build_test_coverage_report_directory)/${PROJECT_NAME:-HorizonUIPluginDemo}Test/cobertura.xml"
_coverage_dest="${KANO_COVERAGE_XML:-Reports/coverage/${PROJECT_NAME:-HorizonUIPluginDemo}/cobertura.xml}"
if [[ -f "${_coverage_src}" ]]; then
    mkdir -p "$(dirname "${_coverage_dest}")"
    cp -f "${_coverage_src}" "${_coverage_dest}"
fi
