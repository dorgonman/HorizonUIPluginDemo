# Installed Engine Upgrade SOP

Use this checklist when moving HorizonUIPluginDemo to a newer installed Unreal Engine.

## Scope

This project currently targets Unreal Engine 5.8 via the installed engine path `H:/EpicGames/Installed/UE_5.8`.

## Steps

1. Create or switch to the target branch, for example `dev/5.8`.
2. Verify the installed engine exists and can launch command-line tools:
   - `H:/EpicGames/Installed/UE_5.8/Engine/Binaries/Win64/UnrealEditor-Cmd.exe`
   - `H:/EpicGames/Installed/UE_5.8/Engine/Build/BatchFiles/RunUAT.bat`
3. Update project metadata:
   - `HorizonUIPluginDemo.uproject` `EngineAssociation`
   - `Plugins/HorizonUIPlugin/HorizonUIPlugin.uplugin` `EngineVersion` and `VersionName`
   - `Config/DefaultGame.ini` `ProjectVersion`
   - `sonar-project.properties` `sonar.projectVersion`
4. Update Jenkins metadata for installed-engine jobs:
   - `.jenkins/config.groovy` `unrealEngineRoot`
   - `.jenkins/config.groovy` `kanobuildUbtArgs` only when the requested compiler is within the engine `PreferredVisualCppVersions`
   - SOURCE_BRANCH selection policy, keeping `main` as the default when no branch is selected
5. Update user-facing docs that name the old engine version.
6. Run local validation before Jenkins:
   - syntax/static checks for changed scripts/config
   - one local installed-engine build for HorizonUIPluginDemo
   - do not set `KANOBUILD_UBT_ARGS` or `PROJECT_UBT_ARGS` for normal validation; leave compiler selection to UE/AutoSDK unless a ticket explicitly pins a preferred compiler
   - no-test report endpoints should remain absent when test parameters are disabled
7. Commit and push the project and submodule branches.
8. Trigger Jenkins with `SOURCE_BRANCH=dev/5.8` and verify:
   - checkout branch evidence in console
   - current-run root artifacts and `.manifest.*` sidecars
   - JenkinsReports diagnostics only
   - JUnit, coverage, and HTML reports only when the corresponding test parameter is enabled

## Do Not Skip

- Do not rely on a green Jenkins result without checking the final artifact list.
- Do not reuse stale root artifacts from an older run.
- Do not trigger Jenkins before the local installed-engine validation has passed.
