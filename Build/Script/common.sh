#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../Base/Script/common.sh"

# =============================================================================
# Override: UGS functions — multi-directory staging support
# =============================================================================
# This override enables UGS operations to capture files from BOTH the engine
# directory AND the project directory by using a relative WorkspaceRootDir.
#
# How it works:
#   - Base behavior: WorkspaceRootDir is set to project_root (captures only project)
#   - Override: WorkspaceRootDir is set to ${WORKSPACE_ROOT_DIR} which resolves
#     to the parent of both engine + project roots
#
# Usage:
#   export WORKSPACE_ROOT_DIR="../../../../.."   # Enable multi-dir (engine + project)
#   unset WORKSPACE_ROOT_DIR                     # Disable (uses normal behavior)
# =============================================================================

# -----------------------------------------------------------------------------
# Helper: resolve workspace root for UGS
# Native projects use engine root so source-build staging lands under Projects/<Project>.
# Foreign projects use WORKSPACE_ROOT_DIR when provided, else parent(project_root),
# preserving either the explicit workspace prefix or the sibling project layout.
_ugs_resolve_workspace_root() {
    local project_root_native="${1:-}"
    local engine_root_native="${2:-}"

    # Native projects always stage relative to engine root so project output lands under Projects/<Project>.
    if [[ "${KANOBUILD_GRAPH_IS_FOREIGN_PROJECT:-false}" == "false" ]]; then
        printf '%s\n' "${engine_root_native}"
    elif build_is_installed_build "${engine_root_native}" && [[ -z "${WORKSPACE_ROOT_DIR:-}" ]]; then
        # Installed foreign base builds stage directly from the project root.
        printf '%s\n' "${project_root_native}"
    elif [[ -n "${WORKSPACE_ROOT_DIR:-}" ]]; then
        # Override foreign builds preserve the wider workspace prefix when provided.
        printf '%s\n' "${WORKSPACE_ROOT_DIR}"
    else
        # Base foreign builds preserve the project as a sibling tree under parent(project_root).
        _ugs_parent_native_path "${project_root_native}"
    fi
}

# Helper: resolve archive workspace root for UGS (for ArchiveWorkspaceRootDir graph option)
# Source builds follow the workspace root so engine + project preserve their shared layout.
# Installed builds stage project content only:
#   - foreign + override keeps WORKSPACE_ROOT_DIR (preserves _Horizon/HorizonUIPluginDemo/...)
#   - all other installed cases use project root (flat Binaries/ + Plugins/)
_ugs_resolve_archive_workspace_root() {
    local project_root_native="${1:-}"
    local engine_root_native="${2:-}"

    if build_is_installed_build "${engine_root_native}"; then
        if [[ "${KANOBUILD_GRAPH_IS_FOREIGN_PROJECT:-false}" == "true" ]] && [[ -n "${WORKSPACE_ROOT_DIR:-}" ]]; then
            printf '%s\n' "${WORKSPACE_ROOT_DIR}"
        else
            printf '%s\n' "${project_root_native}"
        fi
        return 0
    fi

    _ugs_resolve_workspace_root "${project_root_native}" "${engine_root_native}"
}

# Helper: check if engine is an installed (Launcher) build vs source build
build_is_installed_build() {
    local engine_root="${1:-${UNREAL_ENGINE_ROOT:-}}"
    if [[ -z "${engine_root}" ]]; then
        return 1
    fi
    # Installed builds have InstalledBuild.txt marker but no source control markers
    if [[ -f "${engine_root}/Engine/Build/InstalledBuild.txt" ]]; then
        if [[ ! -d "${engine_root}/.git" ]] && [[ ! -f "${engine_root}/.p4config" ]]; then
            return 0  # is installed build
        fi
    fi
    return 1  # is NOT installed build (source build)
}

# =============================================================================
# Helper: collect and validate all platform build metadata from staging
# =============================================================================
# Finds all Build/Metadata/*.json under the staging root,
# validates that all RevisionHash values are identical (inconsistent platforms =
# broken build pipeline), and returns the platform list + shared hash.
#
# Output (on success): "<platform1,platform2,...> <RevisionHash>"
# Output (on failure): "" to stdout, error message to stderr, return 1
#
# Args:
#   $1 — staging base dir (e.g., Intermediate/BuildUGS/ArchiveForUGS/Staging)
# =============================================================================
_ugs_collect_and_validate_staging_metadata() {
    local staging_base="${1:-}"
    [[ -z "${staging_base}" ]] && { echo "Staging base dir required." >&2; return 1; }
    local metadata_files platform_list revision_hash first_hash mismatched platforms

    # Prefer the merged aggregate layout: Staging/Build/Metadata/<Platform>_<Target>.json.
    # Older producer stashes may still contain either Staging/Build/Metadata/build_metadata.json
    # for a single platform or Staging/<Platform>/Build/Metadata/build_metadata.json after
    # a shared-library relocation, so keep those as compatibility fallbacks.
    shopt -s nullglob
    metadata_files=("${staging_base}/Build/Metadata"/*.json)
    if [[ ${#metadata_files[@]} -eq 0 ]]; then
        metadata_files=("${staging_base}"/*/Build/Metadata/build_metadata.json)
    fi
    shopt -u nullglob

    [[ ${#metadata_files[@]} -eq 0 ]] && { echo "No metadata json found under ${staging_base}/Build/Metadata/ or ${staging_base}/<Platform>/Build/Metadata/" >&2; return 1; }

    first_hash=""
    platform_list=""
    mismatched=""

    for metadata_file in "${metadata_files[@]}"; do
        local this_platform this_hash
        this_platform="$(python - "${metadata_file}" <<'PY'
import json, sys, pathlib
data = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8", errors="ignore"))
print(data.get("TargetPlatform", ""))
PY
)"
        this_hash="$(python - "${metadata_file}" <<'PY'
import json, sys, pathlib
data = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8", errors="ignore"))
print(data.get("RevisionHash", ""))
PY
)"

        if [[ -z "${first_hash}" ]]; then
            first_hash="${this_hash}"
            revision_hash="${this_hash}"
            platform_list="${this_platform}"
        else
            if [[ "${this_hash}" != "${first_hash}" ]]; then
                mismatched="${mismatched}  ${this_platform}: ${this_hash}\n"
            fi
            platform_list="${platform_list},${this_platform}"
        fi
    done

    if [[ -n "${mismatched}" ]]; then
        echo "ERROR: RevisionHash mismatch across platforms — inconsistent build." >&2
        echo "All platforms must be built from the same source revision." >&2
        echo "Platform          RevisionHash" >&2
        echo "${mismatched}" | while read -r line; do [[ -n "${line}" ]] && echo "  ${line}" >&2; done
        return 1
    fi

    echo "[ugs_nuget_pack] Collected metadata from platforms: ${platform_list}" >&2
    echo "[ugs_nuget_pack] RevisionHash: ${revision_hash}" >&2

    # Output: "<platform_list> <revision_hash>"
    printf '%s\n' "${platform_list} ${revision_hash}"
}

# =============================================================================
# Helper: check if engine is an installed (Launcher) build vs source build
# =============================================================================

build_source_kano_secret_env() {
    local secret_env_path
    secret_env_path="$(build_kano_secret_env_path)"
    [[ -f "${secret_env_path}" ]] || return 0

    # shellcheck disable=SC1090
    source "${secret_env_path}"
}

build_resolve_env_value() {
    local var_name
    for var_name in "$@"; do
        if [[ -n "${!var_name:-}" ]]; then
            printf '%s\n' "${!var_name}"
            return 0
        fi
    done
    return 1
}

build_resolve_env_value_with_secret_fallback() {
    local value
    if value="$(build_resolve_env_value "$@")"; then
        printf '%s\n' "${value}"
        return 0
    fi

    build_source_kano_secret_env
    build_resolve_env_value "$@"
}

build_default_ugs_archive_staging_dir() {
    printf '%s\n' "$(build_project_root)/Intermediate/BuildUGS/ArchiveForUGS/Staging"
}

build_require_prebuilt_ugs_staging_dir() {
    local quiet candidate explicit_stage_dir default_stage_dir
    quiet="${1:-false}"
    explicit_stage_dir="${UGS_PREBUILT_ARCHIVE_STAGING_DIR:-}"
    default_stage_dir="$(build_default_ugs_archive_staging_dir)"

    for candidate in "${explicit_stage_dir}" "${default_stage_dir}"; do
        [[ -n "${candidate}" ]] || continue
        if [[ -d "${candidate}" ]] && compgen -G "${candidate%/}/*" > /dev/null; then
            shopt -s nullglob
            local metadata_files=("${candidate}/Build/Metadata"/*.json)
            if [[ ${#metadata_files[@]} -eq 0 ]]; then
                metadata_files=("${candidate}"/*/Build/Metadata/build_metadata.json)
            fi
            shopt -u nullglob

            if [[ ${#metadata_files[@]} -gt 0 ]]; then
                printf '%s\n' "${candidate}"
                return 0
            fi

            if [[ "${quiet}" != "true" ]]; then
                echo "UGS staging directory exists but metadata not found under: ${candidate}/Build/Metadata/" >&2
                echo "This may indicate an incomplete Stage phase. Run stage.sh to complete the assembly." >&2
            fi
            return 1
        fi

        if [[ -n "${explicit_stage_dir}" && "${candidate}" == "${explicit_stage_dir}" ]]; then
            if [[ "${quiet}" != "true" ]]; then
                echo "UGS staging directory not found or empty (explicit env var): ${explicit_stage_dir}" >&2
                echo "Populate that directory first, or unset UGS_PREBUILT_ARCHIVE_STAGING_DIR to use the default staging path." >&2
            fi
            return 1
        fi
    done

    if [[ "${quiet}" != "true" ]]; then
        echo "UGS staging directory not found or empty: ${default_stage_dir}" >&2
        echo "Run stage.sh first, or set UGS_PREBUILT_ARCHIVE_STAGING_DIR to an assembled staging directory." >&2
    fi
    return 1
}

build_default_ugs_nuspec_path() {
    printf '%s\n' "$(build_project_root)/.nuget/${PROJECT_NAME}.nuspec"
}

build_default_ugs_nuget_output_dir() {
    printf '%s\n' "$(build_project_root)/Intermediate/BuildUGS/NuGet"
}

# -----------------------------------------------------------------------------
# Override: build_run_ugs_stage
# -----------------------------------------------------------------------------
build_run_ugs_stage() {
    build_prepare_context
    build_require_env_var "UGS_BRANCH"
    # Split BuildGraph's project-file path from Horde's logical key path.
    build_prepare_ugs_project_paths

    local project_root_native engine_root_native workspace_root_dir archive_workspace_root_dir
    project_root_native="$(build_native_path "${REAL_PROJECT_ROOT}")"
    engine_root_native="$(build_native_path "${UNREAL_ENGINE_ROOT}")"
    workspace_root_dir="$(_ugs_resolve_workspace_root "${project_root_native}" "${engine_root_native}")"
    archive_workspace_root_dir="$(_ugs_resolve_archive_workspace_root "${project_root_native}" "${engine_root_native}")"

    local example_graph
    example_graph="$(resolve_build_editor_and_tools_buildgraph_path "${UNREAL_ENGINE_ROOT}")"

    local extra_args=()
    extra_args+=("-Set:ProjectRootDir=${project_root_native}")
    extra_args+=("-Set:WorkspaceRootDir=${workspace_root_dir}")
    extra_args+=("-Set:ArchiveWorkspaceRootDir=${archive_workspace_root_dir}")
    extra_args+=("-Set:UnrealEngineRootDir=${engine_root_native}")
    extra_args+=("-Set:EditorPlatform=${HOST_PLATFORM}")
    extra_args+=("-Set:UProjectPath=${UGS_UPROJECT_PATH}")
    extra_args+=("-Branch=${UGS_BRANCH}")
    extra_args+=("-Set:ProjectName=${PROJECT_NAME}")
    extra_args+=("-Set:IsForeignProject=${KANOBUILD_GRAPH_IS_FOREIGN_PROJECT:-false}")

    # Optional overrides
    extra_args+=("-Set:EditorTarget=$(build_resolve_editor_target)")
    [[ -n "${UGS_ARCHIVE_NAME:-}" ]] && extra_args+=("-Set:ArchiveName=${UGS_ARCHIVE_NAME}")
    # NOTE: UGS_LOCAL_BUILDS_DIR is intentionally NOT honored here.
    # LocalBuilds is derived from WorkspaceRootDir by the graph to ensure
    # staging structure always matches the workspace hierarchy (e.g. _Horizon/Project).
    # Allowing UGS_LOCAL_BUILDS_DIR to override would defeat that guarantee.

    if [[ -f "${UNREAL_ENGINE_ROOT}/Engine/Build/InstalledBuild.txt" ]] && ! build_is_source_build "${UNREAL_ENGINE_ROOT}"; then
        echo "[build_run_ugs_stage] InstalledBuild detected: switching to InstalledBuild compile path (Spawn+Tag, no manifest validation)" >&2
        extra_args+=("-Set:BuildTools=false")
        extra_args+=("-Set:InstalledBuild=true")
    fi

    build_run_engine_buildgraph \
        "${example_graph}" \
        "Stage for UGS" \
        "${UNREAL_ENGINE_ROOT}" \
        "${extra_args[@]}" \
        "$@"
}

# -----------------------------------------------------------------------------
# Override: build_run_ugs_nuget_pack
# -----------------------------------------------------------------------------
# Metadata (authors, owners, description, releaseNotes, tags, etc.) is fully
# defined in the .nuspec file. Only NuspecPath + NugetPackageVersion are needed;
# all other options are derived from the nuspec at pack time.
build_run_ugs_nuget_pack() {
    build_prepare_context
    build_require_env_var "UGS_BRANCH"
    build_prepare_ugs_project_paths

    # -------------------------------------------------------------------------
    # Pre-pack cross-platform consistency check
    # Collect all platform build_metadata.json from staging and verify that
    # RevisionHash is identical across every platform.  Inconsistent hashes
    # mean two platforms were built from different source commits — reject the
    # pack rather than publishing a broken artifact.
    # -------------------------------------------------------------------------
    local prebuilt_stage_dir metadata_result platforms revision_hash
    prebuilt_stage_dir="$(build_require_prebuilt_ugs_staging_dir)" || return 1

    if metadata_result="$(_ugs_collect_and_validate_staging_metadata "${prebuilt_stage_dir}")"; then
        read -r platforms revision_hash <<< "${metadata_result}"
        echo "[build_run_ugs_nuget_pack] Cross-platform RevisionHash check passed (${platforms})" >&2
    else
        echo "[build_run_ugs_nuget_pack] FAILED: RevisionHash mismatch — cannot pack inconsistent build." >&2
        return 1
    fi

    local project_root_native engine_root_native workspace_root_dir archive_workspace_root_dir
    project_root_native="$(build_native_path "${REAL_PROJECT_ROOT}")"
    engine_root_native="$(build_native_path "${UNREAL_ENGINE_ROOT}")"
    workspace_root_dir="$(_ugs_resolve_workspace_root "${project_root_native}" "${engine_root_native}")"
    archive_workspace_root_dir="$(_ugs_resolve_archive_workspace_root "${project_root_native}" "${engine_root_native}")"

    local example_graph
    example_graph="$(resolve_build_editor_and_tools_buildgraph_path "${UNREAL_ENGINE_ROOT}")"

    # Auto-detect nuspec: $(build_project_root)/.nuget/${PROJECT_NAME}.nuspec
    local nuspec_path
    nuspec_path="$(build_default_ugs_nuspec_path)"
    if [[ -f "${nuspec_path}" ]]; then
        echo "[build_run_ugs_nuget_pack] Using nuspec: ${nuspec_path}"
    else
        echo "[build_run_ugs_nuget_pack] Nuspec not found: ${nuspec_path}" >&2
        return 1
    fi

    local extra_args=()
    extra_args+=("-Set:ProjectRootDir=${project_root_native}")
    extra_args+=("-Set:WorkspaceRootDir=${workspace_root_dir}")
    extra_args+=("-Set:ArchiveWorkspaceRootDir=${archive_workspace_root_dir}")
    extra_args+=("-Set:UnrealEngineRootDir=${engine_root_native}")
    extra_args+=("-Set:UProjectPath=${UGS_UPROJECT_PATH}")
    extra_args+=("-Set:UProjectRelativePath=${UGS_UPROJECT_RELATIVE_PATH}")
    extra_args+=("-Set:NuspecPath=$(build_to_engine_arg_path "${nuspec_path}")")
    extra_args+=("-Branch=${UGS_BRANCH}")
    extra_args+=("-Set:PrebuiltArchiveStagingDir=$(build_to_engine_arg_path "${prebuilt_stage_dir}")")

    # Version is the only dynamic metadata; all others live in the nuspec file.
    [[ -n "${UGS_NUGET_PACKAGE_VERSION:-}" ]] && extra_args+=("-Set:NugetPackageVersion=${UGS_NUGET_PACKAGE_VERSION}")

    # TargetPlatform + RevisionHash are included in the NuGet package filename
    # so that distinct platform builds and distinct commits produce distinct packages.
    [[ -n "${platforms:-}" ]]      && extra_args+=("-Set:NugetPackageTargetPlatform=${platforms}")
    [[ -n "${revision_hash:-}" ]]  && extra_args+=("-Set:NugetPackageRevisionHash=${revision_hash}")

    # Optional overrides
    extra_args+=("-Set:EditorTarget=$(build_resolve_editor_target)")
    [[ -n "${UGS_ARCHIVE_NAME:-}" ]] && extra_args+=("-Set:ArchiveName=${UGS_ARCHIVE_NAME}")
    [[ -n "${UGS_NUGET_OUTPUT_DIR:-}" ]] && extra_args+=("-Set:NugetOutputDir=$(build_to_engine_arg_path "${UGS_NUGET_OUTPUT_DIR}")")

    if [[ -f "${UNREAL_ENGINE_ROOT}/Engine/Build/InstalledBuild.txt" ]] && ! build_is_source_build "${UNREAL_ENGINE_ROOT}"; then
        echo "[build_run_ugs_nuget_pack] InstalledBuild detected: switching to InstalledBuild compile path (Spawn+Tag, no manifest validation)" >&2
        extra_args+=("-Set:BuildTools=false")
        extra_args+=("-Set:InstalledBuild=true")
    fi

    build_run_engine_buildgraph \
        "${example_graph}" \
        "Pack NuGet" \
        "${UNREAL_ENGINE_ROOT}" \
        "${extra_args[@]}" \
        "$@"

    # -------------------------------------------------------------------------
    # Post-pack: collect platform build_metadata.json as side-cars
    #
    # BuildGraph's "Pack NuGet" node does not accept platform/hash in the
    # filename template, so those values cannot be embedded in the .nupkg name.
    #
    # Instead, each platform's build_metadata.json is copied to:
    #   <NuGetOutputDir>/build_metadata/<platform>.json
    #
    # CI can then read per-platform metadata from these side-car files.
    # -------------------------------------------------------------------------
    local nuget_output_dir metadata_output_dir
    nuget_output_dir="${UGS_NUGET_OUTPUT_DIR:-$(build_default_ugs_nuget_output_dir)}"
    metadata_output_dir="${nuget_output_dir}/build_metadata"

    mkdir -p "${metadata_output_dir}"

    # Collect platform metadata from staging.  Aggregated UGS staging stores
    # side-by-side platform metadata under Build/Metadata/*.json.
    local metadata_files
    shopt -s nullglob
    metadata_files=("${prebuilt_stage_dir}/Build/Metadata"/*.json)
    if [[ ${#metadata_files[@]} -eq 0 ]]; then
        metadata_files=("${prebuilt_stage_dir}"/*/Build/Metadata/build_metadata.json)
    fi
    shopt -u nullglob

    if [[ ${#metadata_files[@]} -eq 0 ]]; then
        echo "[build_run_ugs_nuget_pack] No metadata json found under ${prebuilt_stage_dir}" >&2
    else
        for metadata_file in "${metadata_files[@]}"; do
            local platform_name
            platform_name="$(python - "${metadata_file}" <<'PY'
import json, pathlib, sys
data = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8", errors="ignore"))
print(data.get("TargetPlatform") or pathlib.Path(sys.argv[1]).stem.split("_")[0])
PY
)"
            if [[ -z "${platform_name}" || "${platform_name}" == "build" ]]; then
                # Compatibility path: Staging/<Platform>/Build/Metadata/build_metadata.json
                platform_name="$(basename "$(dirname "$(dirname "$(dirname "${metadata_file}")")")")"
            fi

            if [[ "$(basename "${metadata_file}")" == "build_metadata.json" ]]; then
                cp "${metadata_file}" "${metadata_output_dir}/${platform_name}.json"
            else
                cp "${metadata_file}" "${metadata_output_dir}/$(basename "${metadata_file}")"
            fi
            echo "[build_run_ugs_nuget_pack] Collected metadata side-car for ${platform_name}: ${metadata_file}"
        done
    fi
}

# -----------------------------------------------------------------------------
# Override: build_run_ugs_perforce
# -----------------------------------------------------------------------------
build_run_ugs_perforce() {
    build_prepare_context
    build_require_env_var "UGS_BRANCH"
    build_prepare_ugs_project_paths
    build_require_env_var "UGS_ARCHIVE_STREAM"

    local project_root_native engine_root_native workspace_root_dir archive_workspace_root_dir
    project_root_native="$(build_native_path "${REAL_PROJECT_ROOT}")"
    engine_root_native="$(build_native_path "${UNREAL_ENGINE_ROOT}")"
    workspace_root_dir="$(_ugs_resolve_workspace_root "${project_root_native}" "${engine_root_native}")"
    archive_workspace_root_dir="$(_ugs_resolve_archive_workspace_root "${project_root_native}" "${engine_root_native}")"

    local example_graph
    example_graph="$(resolve_build_editor_and_tools_buildgraph_path "${UNREAL_ENGINE_ROOT}")"

    local extra_args=()
    extra_args+=("-P4")
    extra_args+=("-Submit")
    extra_args+=("-Set:ProjectRootDir=${project_root_native}")
    extra_args+=("-Set:WorkspaceRootDir=${workspace_root_dir}")
    extra_args+=("-Set:ArchiveWorkspaceRootDir=${archive_workspace_root_dir}")
    extra_args+=("-Set:UnrealEngineRootDir=${engine_root_native}")
    extra_args+=("-Set:UProjectPath=${UGS_UPROJECT_PATH}")
    extra_args+=("-Set:UProjectRelativePath=${UGS_UPROJECT_RELATIVE_PATH}")
    extra_args+=("-Set:ArchiveStream=${UGS_ARCHIVE_STREAM}")
    extra_args+=("-Branch=${UGS_BRANCH}")

    # Optional overrides
    extra_args+=("-Set:EditorTarget=$(build_resolve_editor_target)")
    [[ -n "${UGS_ARCHIVE_NAME:-}" ]] && extra_args+=("-Set:ArchiveName=${UGS_ARCHIVE_NAME}")
    # NOTE: UGS_LOCAL_BUILDS_DIR is intentionally NOT honored here.
    # LocalBuilds is derived from WorkspaceRootDir by the graph to ensure
    # staging structure always matches the workspace hierarchy (e.g. _Horizon/Project).
    # Allowing UGS_LOCAL_BUILDS_DIR to override would defeat that guarantee.

    if [[ -f "${UNREAL_ENGINE_ROOT}/Engine/Build/InstalledBuild.txt" ]] && ! build_is_source_build "${UNREAL_ENGINE_ROOT}"; then
        echo "[build_run_ugs_perforce] InstalledBuild detected: switching to InstalledBuild compile path (Spawn+Tag, no manifest validation)" >&2
        extra_args+=("-Set:BuildTools=false")
        extra_args+=("-Set:InstalledBuild=true")
    fi

    build_run_engine_buildgraph \
        "${example_graph}" \
        "Sync to Perforce" \
        "${UNREAL_ENGINE_ROOT}" \
        "${extra_args[@]}" \
        "$@"
}

build_run_upload_to_horde() {
    build_prepare_context
    build_require_env_var "UGS_BRANCH"
    build_prepare_ugs_project_paths

    local prebuilt_stage_dir project_root_native engine_root_native example_graph
    prebuilt_stage_dir="$(build_require_prebuilt_ugs_staging_dir)" || return 1

    project_root_native="$(build_native_path "${REAL_PROJECT_ROOT}")"
    engine_root_native="$(build_native_path "${UNREAL_ENGINE_ROOT}")"
    example_graph="$(resolve_build_editor_and_tools_buildgraph_path "${UNREAL_ENGINE_ROOT}")"

    local extra_args=()
    extra_args+=("-Set:ProjectRootDir=${project_root_native}")
    extra_args+=("-Set:UnrealEngineRootDir=${engine_root_native}")
    extra_args+=("-Set:ProjectName=${PROJECT_NAME}")
    extra_args+=("-Set:UProjectPath=${UGS_UPROJECT_PATH}")
    extra_args+=("-Set:UProjectRelativePath=${UGS_UPROJECT_RELATIVE_PATH}")
    extra_args+=("-Set:PrebuiltArchiveStagingDir=$(build_to_engine_arg_path "${prebuilt_stage_dir}")")
    extra_args+=("-Branch=${UGS_BRANCH}")

    extra_args+=("-Set:EditorTarget=$(build_resolve_editor_target)")
    [[ -n "${UGS_ARCHIVE_NAME:-}" ]] && extra_args+=("-Set:ArchiveName=${UGS_ARCHIVE_NAME}")
    [[ -n "${UGS_STREAM_ID:-}" ]] && extra_args+=("-Set:StreamId=${UGS_STREAM_ID}")
    [[ -n "${UGS_COMMIT_ID:-}" ]] && extra_args+=("-Set:CommitID=${UGS_COMMIT_ID}")

    build_run_engine_buildgraph \
        "${example_graph}" \
        "Submit To Horde Storage For UGS" \
        "${UNREAL_ENGINE_ROOT}" \
        "${extra_args[@]}" \
        "$@"
}

# -----------------------------------------------------------------------------
# Override: build_run_server
# -----------------------------------------------------------------------------
# The base common.sh uses ${GRAPH_PATH} (matrix graph) which only sets platform
# properties but doesn't define BuildServer target. Use BuildServer.xml directly.
build_run_server() {
    BUILD_TARGET="Server"
    build_prepare_context
    build_write_archive_metadata
    local extra_args extra_target_compile_arguments
    ARCHIVE_DIR="${ARCHIVE_DIR:-$(build_archive_directory "Server" "${TARGET_CONFIGURATION}")}"
    extra_args=("-Set:TargetConfiguration=${TARGET_CONFIGURATION}")
    extra_target_compile_arguments="$(build_variant_extra_target_compile_arguments)"
    if [[ -n "${extra_target_compile_arguments}" ]]; then
        extra_args+=("-Set:ExtraTargetCompileArguments=${extra_target_compile_arguments}")
    fi
    # 'Server' target is NOT supported on InstalledBuild engines.
    if [[ -f "${UNREAL_ENGINE_ROOT}/Engine/Build/InstalledBuild.txt" ]] && ! build_is_source_build "${UNREAL_ENGINE_ROOT}"; then
        echo "ERROR: 'Server' target is not supported on InstalledBuild engines." >&2
        echo "ERROR: InstalledBuild engines lack *.Target.cs files for engine tools." >&2
        echo "ERROR: Build from source with a full UE source installation instead." >&2
        return 1
    fi
    # Use BuildServer.xml directly instead of matrix graph
    local server_graph_path
    server_graph_path="$(build_base_graph_root)/BuildServer.xml"
    build_run_buildgraph \
        "BuildServer" \
        "${server_graph_path}" \
        "${PROJECT_FILE}" \
        "${PROJECT_NAME}" \
        "${UNREAL_ENGINE_ROOT}" \
        "${HOST_PLATFORM}" \
        "${TARGET_PLATFORM}" \
        "${ARCHIVE_DIR}" \
        "${extra_args[@]}" \
        "$@"
}
