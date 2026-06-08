# Jenkins Automation for HorizonUIPluginDemo

This directory contains the Jenkins Pipeline configuration for the HorizonUIPluginDemo project. It uses a shared pipeline library to provide standardized Unreal Engine build and test workflows.

## Entrypoint Overview

The following Jenkinsfiles serve as entrypoints for different CI/CD needs:

- `.jenkins/Jenkinsfile` — Primary all-in-one pipeline (Build + Test).
- `.jenkins/Build/Development.Jenkinsfile` — Development build, test, and report artifact producer.
- `.jenkins/QA/Jenkinsfile` — QA rerun pipeline; consumes `Build/Development` Standalone tar artifacts, optionally unpacks them, then runs Gauntlet Test → Publish HTML without rebuilding.
- `.jenkins/Build/UGSBuild.Jenkinsfile` — UGS artifact and NuGet package producer.
- `.jenkins/Release/Publish.Jenkinsfile` — Release publish pipeline; consumes Development + UGSBuild artifacts, syncs GitHub, pushes NuGet, and publishes curated public GitHub Pages content.

Normal build entrypoints should use the shared project config wrapper instead of owning a root build workspace:

```groovy
unrealPipelineFromProjectConfig(
    projectConfigPath: '.jenkins/config.groovy',
    configOverrides: [
        buildConfiguration: 'Development',
    ]
)
```

This keeps Development, Shipping, and Test Jenkinsfiles as thin copyable templates. The wrapper performs checkout, loads `.jenkins/config.groovy`, infers project metadata where possible, merges job-specific overrides, and delegates to the shared Unreal pipeline.

## Configuration Guide

Global settings are managed in `.jenkins/config.groovy`. Key parameters include:

- `windowsAgentLabel` / `macAgentLabel` / `linuxAgentLabel`: Use Jenkins capability label expressions, for example `windows && unreal` or `mac && unreal`. Avoid physical node names in project Jenkinsfiles.
- `projectRoot`: The path to the project root, currently `.` so the shared library can relocate the workspace safely.
- `unrealHordeServer`: Default Horde URL for UGS-related publishing, default `http://unrealhorde.local/`.
- `bBuildStandalone<Platform>` / `bBuildServer<Platform>`: Target-specific build toggles for the build matrix.
- `bRunTestWin64Standalone`: Runs the Win64 standalone test job.
- QA rerun parameters: `bConsumeUpstreamStandaloneTar` copies/unpacks the upstream Build artifact tar; `bRunTestWin64Standalone` selects the currently implemented rerun platform.
- Coverage is derived internally by the shared library. It is no longer a user-facing Jenkins parameter.
- Consumer Jenkinsfiles should call `unrealPipelineFromProjectConfig(...)` and only pass job-specific overrides. Do not call top-level `load '.jenkins/config.groovy'` from project Jenkinsfiles.

## Adding a New Platform

Follow these steps to extend the pipeline for a new platform:

1. Create a wrapper script at `Build/Script/platform/<platform>/<flow>/script.sh` to handle the low-level build commands.
2. Add a platform build stage to `unrealBuild.groovy` within your fork of the shared pipeline library.
3. Set the corresponding toggle (e.g., `bBuildStandalone<Platform> = true`) in `config.groovy`.
4. Verify the implementation with a local shell test before running on Jenkins.

## Shared Workspace Layout

Windows Jenkins jobs use the shared workspace owned by the shared library. Consumer Jenkinsfiles should stay thin, call `unrealPipelineFromProjectConfig(...)`, and avoid legacy root aliases such as `buildArchiveRoot`, `buildPackageRoot`, `buildPluginRoot`, and `buildUgsRoot`.

UGSBuild uses separate Win64, Mac, and Linux producer workspaces, then stashes only `ArchiveForUGS/Staging/**` from `Intermediate/BuildUGS`. The `UGS Deploy Workspace` stage unstashes those producer artifacts into a platform-derived deploy workspace based on shared roots in `.jenkins/config.groovy`:

```text
Win64: C:/Mount/s/jenkins_ws/HorizonPlugin/HorizonUIPluginDemo/Deploy
Mac: /Users/Shared/agent/jenkins_ws/HorizonPlugin/HorizonUIPluginDemo/Deploy
Linux: /var/jenkins/home/_ws/HorizonPlugin/HorizonUIPluginDemo/Deploy
```

The resulting aggregate staging root is:

```text
Intermediate/BuildUGS/ArchiveForUGS/Staging
```

NuGet packaging runs from that deploy workspace when `bCreateNuGetPackage` is enabled. NuGet push and Perforce publish remain disabled by default in the project entrypoint; Horde upload is controlled by the `bDeployUnrealHordeServer` UGSBuild job parameter. Modern Deploy Targets remain disconnected from real runtime by default (`bRunDeployTargets=false`, `bDeployTargetsDryRunOnly=true`, `bAllowRealDeployTargets=false`).

## Report Structure

The pipeline generates and archives reports in the following locations:

- **Standalone test report site**: `Intermediate/BuildArtifacts/BuildPackage/<Platform>/<Branch>/<Revision>/<Configuration>/StandaloneTestReport/index.html`
- **Test XML**: `Intermediate/BuildArtifacts/BuildPackage/<Platform>/<Branch>/<Revision>/<Configuration>/StandaloneTestReport/Result/junit-report.xml`
- **Coverage XML**: `Intermediate/BuildArtifacts/BuildPackage/<Platform>/<Branch>/<Revision>/<Configuration>/StandaloneTestReport/Coverage/<slug>Test/cobertura.xml`
- **Coverage HTML**: `Intermediate/BuildArtifacts/BuildPackage/<Platform>/<Branch>/<Revision>/<Configuration>/StandaloneTestReport/Coverage/<slug>Test/report-html/index.html`
- **Archived report tar**: `Build/StandaloneTestReport.tar`
- **Archived report metadata**: `Build/build_metadata.json`
- **Archived public docs**: `Build/doc/`
- **UGS aggregate staging root**: `Intermediate/BuildUGS/ArchiveForUGS/Staging`
- **UGS NuGet packages**: `Intermediate/BuildUGS/NuGet/*.nupkg`


## Environment Policy

Do not set OS-specific `PATH` values in project Jenkinsfiles. Jenkinsfiles may run their bootstrap/orchestration stage on any configured bootstrap node, so Windows-only paths must not be injected globally.

Configure tool paths on the matching Jenkins node or in the shared library target-specific execution step instead. For example, Windows Git/Pixi paths belong on Windows nodes, while macOS agents should expose `/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin` through their node environment or launch configuration.

## Jenkins Node Labels

Use capability labels instead of physical node names.

Recommended Windows node labels:

```text
windows unreal autosdk ugs deploy gpu
```

All build agents may also include `lightweight` if they are allowed to run bootstrap/config-loading work. The shared wrapper defaults `bootstrapAgentLabel` to `lightweight`. All real agents that are safe for config-loading/bootstrap work should carry this label. Built-In/Controller executors can eventually be set to `0` once all project Jenkinsfiles use the wrapper.

`autosdk` marks Windows Unreal build agents that can build AutoSDK-managed target platforms such as Android, Linux target, PS5, XSX, and Switch2. `linux` should still mean a Linux host agent, not a Linux target build.

Recommended Mac node labels:

```text
mac unreal deploy
```

The project config should use label expressions such as `windows && unreal && ugs`.
Do not put physical hostnames in reusable Jenkinsfiles.

## Jenkins Admin Setup

The following steps are required before the first run:

1. **Global Pipeline Library**: Configure `kano-jenkins-unreal-pipeline-library` as a Global Trusted Pipeline Library in **Manage Jenkins** → **Configure System**.
2. **Win64 Agent**: Set up Windows Unreal build agents with labels such as `windows unreal autosdk ugs deploy gpu`.
3. **Required Plugins**: Ensure the following plugins are installed:
   - `pipeline`
   - `junit`
   - `cobertura`
   - `htmlpublisher`
   - `git`
   - `copyartifact`

## Release Deploy

`.jenkins/Release/Publish.Jenkinsfile` is intentionally thin and delegates orchestration to `unrealReleaseDeployPipeline()` in the shared Jenkins library.

The deploy job consumes:

- `HorizonPlugin/HorizonUIPluginDemo/Build/Development` — `*StandaloneTestReport.tar` and `Intermediate/BuildArchive/doc/` public docs.
- `HorizonPlugin/HorizonUIPluginDemo/Build/UGSBuild` — `Intermediate/BuildUGS/NuGet/*.nupkg`.

Before publishing to GitHub Pages, coverage source-code HTML is stripped from `Coverage/*/report-html/files` and `Coverage/*/native-html` so public pages keep summary/report navigation without exposing source listings.

Required Jenkins credentials:

- `NUGET_ORG_API_KEY` by default, or the `NUGET_CREDENTIAL_ID` parameter — String credential used by `nuget push` against `NUGET_FEED_URL`.
- `GITHUB_PAGES_TOKEN` by default, or the `GITHUB_PAGES_CREDENTIAL_ID` parameter — String credential with permission to push the configured Pages branch.

## Out of Scope for v1

The following features are not part of the current implementation:

- **Notification Systems**: Integration with Slack, email, or other messaging services.
- **Live Jenkins Runtime Validation**: The pipeline logic is provided as-is without active validation on a live Jenkins instance.


### Loading `.jenkins/config.groovy`

Do not call top-level `load '.jenkins/config.groovy'` from project Jenkinsfiles. Jenkins `load` requires a workspace (`hudson.FilePath`), while Pipeline-from-SCM may only perform lightweight checkout before execution.

Preferred normal build entrypoint pattern:

```groovy
unrealPipelineFromProjectConfig(
    projectConfigPath: '.jenkins/config.groovy',
    configOverrides: [
        buildConfiguration: 'Development',
    ]
)
```

Preferred UGS entrypoint pattern:

```groovy
unrealUgsBuildPipeline(
    projectConfigPath: '.jenkins/config.groovy',
    configOverrides: [
        bCleanBuild: params.bCleanBuild,
        bDeployUnrealHordeServer: params.bDeployUnrealHordeServer,
        bFailFast: params.bFailFast,
    ]
)
```

`bFailFast` is exposed on UGSBuild jobs and forwarded into the shared library config so Jenkins parallel fail-fast behavior is controlled by the job parameter instead of being hardcoded in the job body.

Agent routing belongs in `.jenkins/config.groovy` as capability label expressions, for example:

```groovy
windowsAgentLabel     : 'windows && unreal',
win64UgsAgentLabel    : 'windows && unreal && ugs',
ugsDeployAgentLabel   : 'windows && unreal && deploy',
gpuTestAgentLabel     : 'windows && unreal && gpu',
autoSdkAgentLabel     : 'windows && unreal && autosdk',
linuxTargetAgentLabel : 'windows && unreal && autosdk',
macAgentLabel         : 'mac && unreal',
macDeployAgentLabel   : 'mac && unreal && deploy',
iosAgentLabel         : 'mac && unreal',
```

Use `linuxTargetAgentLabel` for Linux target cross-compilation. Keep `linuxAgentLabel` for Linux host agents only.

If a legacy Declarative job still loads project config directly, do it inside a stage after `checkout scm`, not at Pipeline top level. Prefer migrating it to `unrealPipelineFromProjectConfig(...)` instead.

### Bootstrap agent for thin build entrypoints

`unrealPipelineFromProjectConfig()` currently uses a bootstrap/orchestration node for checkout,
config loading, and root pipeline steps. Set it explicitly in project Jenkinsfiles while
normal build orchestration still requires a workspace context:

```groovy
unrealPipelineFromProjectConfig(
    bootstrapAgentLabel: 'lightweight',
    projectConfigPath: '.jenkins/config.groovy',
    configOverrides: [...]
)
```

Keeping the bootstrap label as `lightweight` intentionally allows bootstrap/config-loading to run on any lightweight-capable agent. This helps expose node environment issues early instead of hiding them behind controller-only routing. Once wrapper-based build entrypoints are stable, the Built-In Node executor can be set to `0`.
