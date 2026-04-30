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

# Copy ctest-report.xml to the JUnit path expected by unrealTest.groovy.
_report_dir="$(build_test_result_report_directory)"
_dest_dir="${KANO_TEST_REPORT_DIR:-Reports/tests/${PROJECT_NAME:-HorizonUIPluginDemo}}"
mkdir -p "${_dest_dir}"
if [[ -f "${_report_dir}/ctest-report.xml" ]]; then
    cp -f "${_report_dir}/ctest-report.xml" "${_dest_dir}/tests.xml"
fi