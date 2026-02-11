#!/usr/bin/env bash
# =============================================================================
# Override: reports/verify/verify_ugs_staging_cases.sh
# Verifies the 8-case UGS root-resolution contract for both base and override.
# On MSYS: mktemp returns Unix paths, so fixture roots are pre-converted to
# native format (matching what _ugs_resolve_* produces internally).
# On Linux/Mac: mktemp already returns native paths, so conversion is a no-op.
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="${REPO_ROOT:-$(cd "${SCRIPT_DIR}/../../.." && pwd)}"  # reports→Script→Build→repo_root
# NOTE: platform wrappers export REPO_ROOT before invoking to ensure correct resolution
BASE_COMMON="${REPO_ROOT}/Build/Base/Script/common.sh"
OVERRIDE_COMMON="${REPO_ROOT}/Build/Script/common.sh"
PROJECT_NAME="HorizonUIPluginDemo"

TMP_ROOT="$(mktemp -d 2>/dev/null || mktemp -d -t verify-ugs-staging-cases)"
trap 'rm -rf "${TMP_ROOT}"' EXIT

FAILURES=0
ASSERTIONS=0

log_note() {
    printf 'NOTE: %s\n' "$*"
}

assert_eq() {
    local layer="$1"
    local case_id="$2"
    local field="$3"
    local expected="$4"
    local actual="$5"
    ASSERTIONS=$((ASSERTIONS + 1))
    if [[ "${expected}" == "${actual}" ]]; then
        printf 'PASS [%s] %-33s %s\n' "${layer}" "${case_id}" "${field}=${actual}"
    else
        printf 'FAIL [%s] %-33s %s\n' "${layer}" "${case_id}" "${field}" >&2
        printf '  expected: %s\n' "${expected}" >&2
        printf '  actual:   %s\n' "${actual}" >&2
        FAILURES=$((FAILURES + 1))
    fi
}

# Source both common files once so build_native_path is available for fixture setup.
# shellcheck disable=SC1090
source "${BASE_COMMON}"
# shellcheck disable=SC1090
source "${OVERRIDE_COMMON}"

setup_fixture_tree() {
    # On MSYS, mktemp returns Unix paths but _ugs_resolve_* internally calls
    # build_native_path(). Pre-convert fixture roots to native format so
    # assertions match actual UGS output. On Linux/Mac this is a no-op.
    local source_engine installed_engine
    source_engine="$(build_native_path "$(mktemp -d 2>/dev/null || mktemp -d -t verify-ugs-staging-cases)")"
    installed_engine="$(build_native_path "$(mktemp -d 2>/dev/null || mktemp -d -t verify-ugs-staging-cases)")"

    mkdir -p "${source_engine}/Engine/Build" \
             "${source_engine}/Projects/${PROJECT_NAME}" \
             "${installed_engine}/Engine/Build" \
             "${installed_engine}/Projects/${PROJECT_NAME}" \
             "$(build_native_path "${TMP_ROOT}/foreign-source-base")/${PROJECT_NAME}" \
             "$(build_native_path "${TMP_ROOT}/foreign-installed-base")/${PROJECT_NAME}" \
             "$(build_native_path "${TMP_ROOT}/_Horizon")/${PROJECT_NAME}"

    touch "${installed_engine}/Engine/Build/InstalledBuild.txt"

    export FIXTURE_SOURCE_ENGINE_NATIVE="${source_engine}"
    export FIXTURE_INSTALLED_ENGINE_NATIVE="${installed_engine}"
    export FIXTURE_NATIVE_SOURCE_PROJECT_NATIVE="${source_engine}/Projects/${PROJECT_NAME}"
    export FIXTURE_NATIVE_INSTALLED_PROJECT_NATIVE="${installed_engine}/Projects/${PROJECT_NAME}"
    export FIXTURE_FOREIGN_SOURCE_BASE_PARENT_NATIVE="$(build_native_path "${TMP_ROOT}/foreign-source-base")"
    export FIXTURE_FOREIGN_SOURCE_BASE_PROJECT_NATIVE="$(build_native_path "${TMP_ROOT}/foreign-source-base")/${PROJECT_NAME}"
    export FIXTURE_FOREIGN_INSTALLED_BASE_PROJECT_NATIVE="$(build_native_path "${TMP_ROOT}/foreign-installed-base")/${PROJECT_NAME}"
    export FIXTURE_WORKSPACE_OVERRIDE_NATIVE="$(build_native_path "${TMP_ROOT}/_Horizon")"
    export FIXTURE_WORKSPACE_OVERRIDE_PROJECT_NATIVE="$(build_native_path "${TMP_ROOT}/_Horizon")/${PROJECT_NAME}"
}

run_case_matrix() {
    local layer_name="$1"
    local common_path="$2"

    # Re-source to ensure functions are available (idempotent after initial source above)
    # shellcheck disable=SC1090
    source "${common_path}"

    build_is_source_build() {
        local engine_root="${1:-}"
        if [[ -f "${engine_root}/Engine/Build/InstalledBuild.txt" ]]; then
            return 1
        fi
        return 0
    }

    while IFS='|' read -r case_id is_foreign engine_root project_root workspace_override expected_workspace expected_archive; do
        [[ -n "${case_id}" ]] || continue

        export KANOBUILD_GRAPH_IS_FOREIGN_PROJECT="${is_foreign}"
        if [[ -n "${workspace_override}" ]]; then
            export WORKSPACE_ROOT_DIR="${workspace_override}"
        else
            unset WORKSPACE_ROOT_DIR
        fi

        actual_workspace="$(_ugs_resolve_workspace_root "${project_root}" "${engine_root}")"
        actual_archive="$(_ugs_resolve_archive_workspace_root "${project_root}" "${engine_root}")"

        assert_eq "${layer_name}" "${case_id}" "WorkspaceRootDir" "${expected_workspace}" "${actual_workspace}"
        assert_eq "${layer_name}" "${case_id}" "ArchiveWorkspaceRootDir" "${expected_archive}" "${actual_archive}"
    done <<EOF
Source_Base_Native|false|${FIXTURE_SOURCE_ENGINE_NATIVE}|${FIXTURE_NATIVE_SOURCE_PROJECT_NATIVE}||${FIXTURE_SOURCE_ENGINE_NATIVE}|${FIXTURE_SOURCE_ENGINE_NATIVE}
Source_Override_Native|false|${FIXTURE_SOURCE_ENGINE_NATIVE}|${FIXTURE_NATIVE_SOURCE_PROJECT_NATIVE}|${FIXTURE_WORKSPACE_OVERRIDE_NATIVE}|${FIXTURE_SOURCE_ENGINE_NATIVE}|${FIXTURE_SOURCE_ENGINE_NATIVE}
Source_Base_Foreign|true|${FIXTURE_SOURCE_ENGINE_NATIVE}|${FIXTURE_FOREIGN_SOURCE_BASE_PROJECT_NATIVE}||${FIXTURE_FOREIGN_SOURCE_BASE_PARENT_NATIVE}|${FIXTURE_FOREIGN_SOURCE_BASE_PARENT_NATIVE}
Source_Override_Foreign|true|${FIXTURE_SOURCE_ENGINE_NATIVE}|${FIXTURE_WORKSPACE_OVERRIDE_PROJECT_NATIVE}|${FIXTURE_WORKSPACE_OVERRIDE_NATIVE}|${FIXTURE_WORKSPACE_OVERRIDE_NATIVE}|${FIXTURE_WORKSPACE_OVERRIDE_NATIVE}
Installed_Base_Native|false|${FIXTURE_INSTALLED_ENGINE_NATIVE}|${FIXTURE_NATIVE_INSTALLED_PROJECT_NATIVE}||${FIXTURE_INSTALLED_ENGINE_NATIVE}|${FIXTURE_NATIVE_INSTALLED_PROJECT_NATIVE}
Installed_Override_Native|false|${FIXTURE_INSTALLED_ENGINE_NATIVE}|${FIXTURE_NATIVE_INSTALLED_PROJECT_NATIVE}|${FIXTURE_WORKSPACE_OVERRIDE_NATIVE}|${FIXTURE_INSTALLED_ENGINE_NATIVE}|${FIXTURE_NATIVE_INSTALLED_PROJECT_NATIVE}
Installed_Base_Foreign|true|${FIXTURE_INSTALLED_ENGINE_NATIVE}|${FIXTURE_FOREIGN_INSTALLED_BASE_PROJECT_NATIVE}||${FIXTURE_FOREIGN_INSTALLED_BASE_PROJECT_NATIVE}|${FIXTURE_FOREIGN_INSTALLED_BASE_PROJECT_NATIVE}
Installed_Override_Foreign|true|${FIXTURE_INSTALLED_ENGINE_NATIVE}|${FIXTURE_WORKSPACE_OVERRIDE_PROJECT_NATIVE}|${FIXTURE_WORKSPACE_OVERRIDE_NATIVE}|${FIXTURE_WORKSPACE_OVERRIDE_NATIVE}|${FIXTURE_WORKSPACE_OVERRIDE_NATIVE}
EOF
}

main() {
    log_note "This verifier checks only the 8-case root-resolution contract; it does not compile or run BuildGraph."
    log_note "Before any real compile after switching InstalledBuild <-> SourceBuild, delete ${REPO_ROOT}/Intermediate/Build."

    setup_fixture_tree

    run_case_matrix "base" "${BASE_COMMON}"
    run_case_matrix "override" "${OVERRIDE_COMMON}"

    printf 'Assertions: %d\n' "${ASSERTIONS}"
    if [[ "${FAILURES}" -ne 0 ]]; then
        printf 'UGS staging matrix verification FAILED (%d mismatches)\n' "${FAILURES}" >&2
        exit 1
    fi
    printf 'UGS staging matrix verification PASSED\n'
}

main "$@"