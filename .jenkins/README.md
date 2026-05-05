# Jenkins Automation for HorizonUIPluginDemo

This directory contains the Jenkins Pipeline configuration for the HorizonUIPluginDemo project. It uses a shared pipeline library to provide standardized Unreal Engine build and test workflows.

## Entrypoint Overview

The following Jenkinsfiles serve as entrypoints for different CI/CD needs:

- `.jenkins/Jenkinsfile` — Primary all-in-one pipeline (Build + Test).
- `.jenkins/Build/Development.Jenkinsfile` — Development build, test, and report artifact producer.
- `.jenkins/Build/UGSBuild.Jenkinsfile` — UGS artifact and NuGet package producer.
- `.jenkins/Release/Jenkinsfile` — Release deploy pipeline; consumes Development + UGSBuild artifacts, pushes NuGet, and publishes curated public GitHub Pages content.

## Configuration Guide

Global settings are managed in `.jenkins/config.groovy`. Key parameters include:

- `agentLabel`: Must match your Jenkins agent pool name (e.g., `unreal-win64`).
- `projectRoot`: The path to the project root, currently `.` so the shared library can relocate the workspace safely.
- `unrealHordeServer`: Default Horde URL for UGS-related publishing, default `http://unrealhorde.local/`.
- `bBuildStandalone<Platform>` / `bBuildServer<Platform>`: Target-specific build toggles for the build matrix.
- `bRunTestStandaloneWin64`: Runs the Win64 standalone test job.
- Coverage is derived internally by the shared library. It is no longer a user-facing Jenkins parameter.

## Adding a New Platform

Follow these steps to extend the pipeline for a new platform:

1. Create a wrapper script at `Build/Script/platform/<platform>/<flow>/script.sh` to handle the low-level build commands.
2. Add a platform build stage to `unrealBuild.groovy` within your fork of the shared pipeline library.
3. Set the corresponding toggle (e.g., `bBuildStandalone<Platform> = true`) in `config.groovy`.
4. Verify the implementation with a local shell test before running on Jenkins.

## Shared Workspace Layout

Windows Jenkins jobs use the shared workspace owned by the shared library. Consumer Jenkinsfiles should stay thin and should not implement their own workspace helpers.

## Report Structure

The pipeline generates and archives reports in the following locations:

- **Standalone test report site**: `Intermediate/BuildPackage/<Platform>/<Branch>/<Revision>/<Configuration>/StandaloneTestReport/index.html`
- **Test XML**: `Intermediate/BuildPackage/<Platform>/<Branch>/<Revision>/<Configuration>/StandaloneTestReport/Result/junit-report.xml`
- **Coverage XML**: `Intermediate/BuildPackage/<Platform>/<Branch>/<Revision>/<Configuration>/StandaloneTestReport/Coverage/<slug>Test/cobertura.xml`
- **Coverage HTML**: `Intermediate/BuildPackage/<Platform>/<Branch>/<Revision>/<Configuration>/StandaloneTestReport/Coverage/<slug>Test/report-html/index.html`
- **Archived report tar**: `Intermediate/BuildArchive/<Project>-<Platform>-<Configuration>-StandaloneTestReport.tar`

## Jenkins Admin Setup

The following steps are required before the first run:

1. **Global Pipeline Library**: Configure `jenkins-unreal-pipeline-library` as a Global Trusted Pipeline Library in **Manage Jenkins** → **Configure System**.
2. **Win64 Agent**: Set up a Windows agent with the label `unreal-win64`.
3. **Required Plugins**: Ensure the following plugins are installed:
   - `pipeline`
   - `junit`
   - `cobertura`
   - `htmlpublisher`
   - `git`

## Release Deploy

`.jenkins/Release/Jenkinsfile` is intentionally thin and delegates orchestration to `unrealReleaseDeployPipeline()` in the shared Jenkins library.

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
