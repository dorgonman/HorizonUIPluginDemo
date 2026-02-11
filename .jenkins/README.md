# Jenkins Automation for HorizonUIPluginDemo

This directory contains the Jenkins Pipeline configuration for the HorizonUIPluginDemo project. It uses a shared pipeline library to provide standardized Unreal Engine build and test workflows.

## Entrypoint Overview

The following Jenkinsfiles serve as entrypoints for different CI/CD needs:

- `.jenkins/Jenkinsfile` — Primary all-in-one pipeline (Build + Test).
- `.jenkins/Build/Development.Jenkinsfile` — Development build config.
- `.jenkins/Build/Test.Jenkinsfile` — Test-focused package build config.
- `.jenkins/Build/Shipping.Jenkinsfile` — Shipping/plugin distribution build config.
- `.jenkins/Build/UGSBuild.Jenkinsfile` — UGS pipeline entrypoint with explicit Build, PrepareDeploy, and Deploy phases.

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

- **Test XML**: `Intermediate/BuildArchive/Reports/tests/<slug>/tests.xml`
- **Coverage XML**: `Intermediate/BuildArchive/Reports/coverage/<slug>/cobertura.xml`
- **Coverage HTML**: `Intermediate/BuildArchive/Reports/coverage/<slug>/report-html/index.html`
- **Consolidated Dashboard**: `Intermediate/BuildArchive/Reports/index.html`

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

## Out of Scope for v1

The following features are not part of the current implementation:

- **Deploy/Release Automation**: Production publication targets still require runtime validation and project-specific credentials/scripts.
- **Notification Systems**: Integration with Slack, email, or other messaging services.
- **Live Jenkins Runtime Validation**: The pipeline logic is provided as-is without active validation on a live Jenkins instance.
