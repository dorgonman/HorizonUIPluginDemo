// .jenkins/Build/Development.Jenkinsfile
// Thin consumer entrypoint for the Development build config.

@Library('jenkins-unreal-pipeline-library') _

pipeline {
    agent none

    environment {
        UNREAL_BUILD_MACHINE = '1'
        PATH = "C:\\Program Files\\Git\\bin;C:\\Program Files\\Git\\usr\\bin;C:\\Users\\dorgon.chang\\.pixi\\bin;C:\\Windows\\System32;C:\\Windows;C:\\Windows\\System32\\Wbem;${env.PATH}"
    }

    options {
        skipDefaultCheckout(true)
    }

    parameters {
        // === Standalone / Server Matrix ===
        booleanParam name: 'bBuildStandaloneWin64', defaultValue: true, description: 'Build Win64 standalone target'
        booleanParam name: 'bBuildStandaloneAndroid', defaultValue: true, description: 'Build Android standalone target'
        booleanParam name: 'bBuildStandaloneIOS', defaultValue: false, description: 'Build iOS standalone target (requires Mac agent + Apple Developer Plan)'
        booleanParam name: 'bBuildStandaloneMac', defaultValue: false, description: 'Build Mac standalone target (requires Mac agent)'
        booleanParam name: 'bBuildStandaloneLinux', defaultValue: false, description: 'Build Linux standalone target'

        // === Plugin Booleans ===
        booleanParam name: 'bBuildPluginWin64', defaultValue: true, description: 'Build Win64 Plugin Shipping'
        booleanParam name: 'bBuildPluginAndroid', defaultValue: true, description: 'Build Android Plugin Shipping (requires Win64 agent + AutoSDK)'
        booleanParam name: 'bBuildPluginIOS', defaultValue: true, description: 'Build iOS Plugin Shipping (requires Mac agent + Apple Developer Plan)'
        booleanParam name: 'bBuildPluginMac', defaultValue: true, description: 'Build Mac Plugin Shipping (requires Mac agent + Apple Developer Plan)'
        booleanParam name: 'bBuildPluginLinux', defaultValue: false, description: 'Build Linux Plugin Shipping'

        // === Test ===
        booleanParam name: 'bRunTestWin64Standalone', defaultValue: true, description: 'Run Win64 standalone tests'

        // === Artifact archival ===
        booleanParam name: 'bArchiveTar', defaultValue: true, description: 'Archive PrepareDeploy tar/manifest artifacts. Disable for fast test/coverage iterations.'

        // === Sentry Deploy Symbols ===
        booleanParam name: 'bDeploySentrySymbols', defaultValue: true, description: 'After standalone builds, create Sentry release/deploy records and upload debug symbols'
        booleanParam name: 'bDeploySentryBundleSources', defaultValue: true, description: 'Run sentry-cli difutil bundle-sources and upload source context with debug symbols. Enable only for projects allowed to upload source code.'
        string name: 'SENTRY_CREDENTIAL_ID', defaultValue: 'SENTRY_AUTH_INFO', description: 'Jenkins username/password credential: username=SENTRY_URL, password=SENTRY_AUTH_TOKEN'
        string name: 'SENTRY_ORG', defaultValue: 'kanohorizonia', description: 'Sentry organization slug for this project'
        string name: 'SENTRY_PROJECT', defaultValue: 'horizonuiplugindemo', description: 'Sentry project slug for this project'
        string name: 'SENTRY_ENVIRONMENT', defaultValue: 'dev', description: 'Sentry deploy environment name'

        // === PreCompileEngine ===
        booleanParam name: 'bCopyPreCompileEngine', defaultValue: true, description: 'Copy CustomBuildEvent/PreCompileEngine/* to UNREAL_ENGINE_ROOT/ before building'

        // === PreArchive ===
        string name: 'PRE_ARCHIVE_COPY_STEP', defaultValue: 'Default', description: 'Step name under CustomBuildEvent/PreArchive/ (e.g. ForDev). If empty, PreArchive copy is skipped.'

        // === FailFast ===
        booleanParam name: 'bFailFast', defaultValue: false, description: 'Abort all parallel branches when any one fails (default: off — all branches complete regardless)'

        // === Prerequisites ===
        booleanParam name: 'bInstallPrerequisites', defaultValue: false, description: 'Install prerequisites before building (runs Build/Base/install-prerequisites.sh)'

        // === Clean ===
        booleanParam name: 'bCleanSCM', defaultValue: false, description: 'Run git checkout -f -- . && git clean -ddfx . to wipe all unstaged changes before building (also applies to submodules)'
        string name: 'WIN64_SHARED_WORKSPACE_ROOT', defaultValue: '', description: 'Override Win64 shared workspace root. Empty uses config.groovy.'
        string name: 'MAC_SHARED_WORKSPACE_ROOT', defaultValue: '', description: 'Override Mac shared workspace root. Empty uses config.groovy.'
        string name: 'LINUX_SHARED_WORKSPACE_ROOT', defaultValue: '', description: 'Override Linux shared workspace root. Empty uses config.groovy.'
    }

    stages {
        stage('Build') {
            steps {
                script {
                    unrealPipelineFromProjectConfig(
                        projectConfigPath: '.jenkins/config.groovy',
                        configOverrides: [
                            bCleanSCM: params.bCleanSCM,
                            bInstallPrerequisites: params.bInstallPrerequisites,
                            bBuildStandaloneWin64: params.bBuildStandaloneWin64,
                            bBuildStandaloneAndroid: params.bBuildStandaloneAndroid,
                            bBuildStandaloneIOS: params.bBuildStandaloneIOS,
                            bBuildStandaloneMac: params.bBuildStandaloneMac,
                            bBuildStandaloneLinux: params.bBuildStandaloneLinux,
                            bBuildPluginWin64: params.bBuildPluginWin64,
                            bBuildPluginAndroid: params.bBuildPluginAndroid,
                            bBuildPluginIOS: params.bBuildPluginIOS,
                            bBuildPluginMac: params.bBuildPluginMac,
                            bBuildPluginLinux: params.bBuildPluginLinux,
                            bRunTestWin64Standalone: params.bRunTestWin64Standalone,
                            bArchiveTar: params.bArchiveTar,
                            bDeploySentrySymbols: params.bDeploySentrySymbols,
                            bDeploySentryForeignUnrealEngineSymbols: false,
                            bDeploySentryBundleSources: params.bDeploySentryBundleSources,
                            sentryCredentialId: params.SENTRY_CREDENTIAL_ID?.trim(),
                            sentryOrg: params.SENTRY_ORG?.trim(),
                            sentryProject: params.SENTRY_PROJECT?.trim(),
                            sentryEnvironment: params.SENTRY_ENVIRONMENT?.trim(),
                            bCopyPreCompileEngine: params.bCopyPreCompileEngine,
                            preArchiveCopyStep: params.PRE_ARCHIVE_COPY_STEP?.trim(),
                            bFailFast: params.bFailFast,
                            win64SharedWorkspaceRoot: params.WIN64_SHARED_WORKSPACE_ROOT?.trim(),
                            macSharedWorkspaceRoot: params.MAC_SHARED_WORKSPACE_ROOT?.trim(),
                            linuxSharedWorkspaceRoot: params.LINUX_SHARED_WORKSPACE_ROOT?.trim(),
                            workspaceSlot: 'Package',
                            buildConfiguration: 'Development',
                        ]
                    )
                }
            }
        }
    }
}
