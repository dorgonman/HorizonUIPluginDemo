#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Resolve REPO_ROOT from wrapper location (platform/<os>/ci/)
# ci → platform → Script → Build → repo_root
REPO_ROOT="$(cd "${SCRIPT_DIR}/../../../../.." && pwd)"
export REPO_ROOT
exec bash "${SCRIPT_DIR}/../../../reports/verify/verify_ugs_staging_cases.sh" "$@"