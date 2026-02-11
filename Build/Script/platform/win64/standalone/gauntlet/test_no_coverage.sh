#!/usr/bin/env bash
# Build/Script/platform/win64/standalone/gauntlet/test_no_coverage.sh
# Local override for gauntlet test execution.
# Delegates to Build/Base/.../gauntlet/test_no_coverage.sh
# then copies ctest-report.xml to the path expected by unrealTest.groovy:
#   ${KANO_TEST_XML:-Reports/tests/${slug}/tests.xml}

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/../../../../../../Base/Script/platform/win64/standalone/gauntlet/test_no_coverage.sh"

# Copy ctest-report.xml to the JUnit path expected by unrealTest.groovy.
# The base script places ctest-report.xml at:
#   ${PROJECT_ROOT}/Intermediate/BuildArchive/AutomationTest/Report/<platform>/<config>/<buildKind>/Result/
# But unrealTest.groovy expects tests.xml at:
#   Reports/tests/${slug}/tests.xml  (via KANO_TEST_XML env var)
#
# KANO_TEST_XML is set by kano_report_init_layout() inside build_render_static_reports(),
# but build_generate_test_static_report() only reads ctest-report.xml and writes HTML —
# it does NOT copy ctest-report.xml → tests.xml. We fix that here.
_report_dir="$(build_test_result_report_directory)"
_dest_dir="${KANO_TEST_REPORT_DIR:-Reports/tests/${PROJECT_NAME:-HorizonUIPluginDemo}}"
mkdir -p "${_dest_dir}"
if [[ -f "${_report_dir}/ctest-report.xml" ]]; then
    cp -f "${_report_dir}/ctest-report.xml" "${_dest_dir}/tests.xml"
fi
