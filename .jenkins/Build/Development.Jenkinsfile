// .jenkins/Build/Development.Jenkinsfile
// Thin consumer entrypoint for the Development build config.

@Library('kano-jenkins-unreal-pipeline-library') _

pipeline {
    agent none

    environment {
        UNREAL_BUILD_MACHINE = '1'
    }

    options {
        skipDefaultCheckout(true)
    }

    triggers {
        cron('H H * * *')
    }

    parameters {
        // === Standalone / Server Matrix ===
        booleanParam name: 'bBuildStandaloneWin64', defaultValue: true, description: 'Build Win64 standalone target'
        booleanParam name: 'bBuildStandaloneAndroid', defaultValue: false, description: 'Build Android standalone target'
        booleanParam name: 'bBuildStandaloneIOS', defaultValue: false, description: 'Build iOS standalone target (requires Mac agent + Apple Developer Plan)'
        booleanParam name: 'bBuildStandaloneMac', defaultValue: false, description: 'Build Mac standalone target (requires Mac agent)'
        booleanParam name: 'bBuildStandaloneLinux', defaultValue: false, description: 'Build Linux standalone target'
        booleanParam name: 'bBuildStandaloneXSX', defaultValue: false, description: 'Build Xbox Series X standalone target'
        booleanParam name: 'bBuildStandalonePS5', defaultValue: false, description: 'Build PlayStation 5 standalone target'
        booleanParam name: 'bBuildStandaloneSwitch2', defaultValue: false, description: 'Build Nintendo Switch 2 standalone target'

        // === Plugin Booleans ===
        booleanParam name: 'bValidatePlugins', defaultValue: false, description: 'Run plugin BuildPlugin validation. Plugin target toggles are ignored unless this is enabled.'
        booleanParam name: 'bBuildPluginWin64', defaultValue: false, description: 'Build Win64 Plugin Shipping'
        booleanParam name: 'bBuildPluginAndroid', defaultValue: false, description: 'Build Android Plugin Shipping (requires Win64 agent + AutoSDK)'
        booleanParam name: 'bBuildPluginIOS', defaultValue: false, description: 'Build iOS Plugin Shipping (requires Mac agent + Apple Developer Plan)'
        booleanParam name: 'bBuildPluginMac', defaultValue: false, description: 'Build Mac Plugin Shipping (requires Mac agent + Apple Developer Plan)'
        booleanParam name: 'bBuildPluginLinux', defaultValue: false, description: 'Build Linux Plugin Shipping'
        booleanParam name: 'bBuildPluginXSX', defaultValue: false, description: 'Build Xbox Series X Plugin Shipping'
        booleanParam name: 'bBuildPluginPS5', defaultValue: false, description: 'Build PS5 Plugin Shipping'
        booleanParam name: 'bBuildPluginSwitch2', defaultValue: false, description: 'Build Switch 2 Plugin Shipping'

        // === Test ===
        booleanParam name: 'bRunTestWin64Standalone', defaultValue: false, description: 'Run Win64 standalone tests'

        // === Artifact archival ===
        booleanParam name: 'bArchiveTar', defaultValue: true, description: 'Archive PrepareDeploy tar/manifest artifacts. Disable for fast test/coverage iterations.'

        // === Sentry Deploy Symbols ===
        booleanParam name: 'bDeploySentrySymbols', defaultValue: false, description: 'After standalone builds, create Sentry release/deploy records and upload debug symbols'
        booleanParam name: 'bDeploySentryBundleSources', defaultValue: false, description: 'Run sentry-cli difutil bundle-sources and upload source context with debug symbols. Enable only for projects allowed to upload source code.'
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
        booleanParam name: 'bCleanBuild', defaultValue: false, description: 'Run recursive git reset/clean (-ddfx) before building. Leave off for incremental builds.'
        string name: 'WIN64_SHARED_WORKSPACE_ROOT', defaultValue: '', description: 'Override Win64 shared workspace root. Empty uses config.groovy.'
        string name: 'MAC_SHARED_WORKSPACE_ROOT', defaultValue: '', description: 'Override Mac shared workspace root. Empty uses config.groovy.'
        string name: 'LINUX_SHARED_WORKSPACE_ROOT', defaultValue: '', description: 'Override Linux shared workspace root. Empty uses config.groovy.'
    }

    stages {
        stage('Build') {
            steps {
                script {
                    Map runtimeOverrides = [
                        bCleanBuild: params.bCleanBuild,
                        bInstallPrerequisites: params.bInstallPrerequisites,
                        bBuildStandaloneWin64: params.bBuildStandaloneWin64,
                        bBuildStandaloneAndroid: params.bBuildStandaloneAndroid,
                        bBuildStandaloneIOS: params.bBuildStandaloneIOS,
                        bBuildStandaloneMac: params.bBuildStandaloneMac,
                        bBuildStandaloneLinux: params.bBuildStandaloneLinux,
                        bBuildStandaloneXSX: params.bBuildStandaloneXSX,
                        bBuildStandalonePS5: params.bBuildStandalonePS5,
                        bBuildStandaloneSwitch2: params.bBuildStandaloneSwitch2,
                        bValidatePlugins: params.bValidatePlugins,
                        bBuildPluginWin64: params.bBuildPluginWin64,
                        bBuildPluginAndroid: params.bBuildPluginAndroid,
                        bBuildPluginIOS: params.bBuildPluginIOS,
                        bBuildPluginMac: params.bBuildPluginMac,
                        bBuildPluginLinux: params.bBuildPluginLinux,
                        bBuildPluginXSX: params.bBuildPluginXSX,
                        bBuildPluginPS5: params.bBuildPluginPS5,
                        bBuildPluginSwitch2: params.bBuildPluginSwitch2,
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
                        workspaceSlot: 'Package',
                        buildConfiguration: 'Development',
                    ]

                    String win64WorkspaceRootOverride = params.WIN64_SHARED_WORKSPACE_ROOT?.trim()
                    if (win64WorkspaceRootOverride) {
                        runtimeOverrides.win64SharedWorkspaceRoot = win64WorkspaceRootOverride
                    }

                    String macWorkspaceRootOverride = params.MAC_SHARED_WORKSPACE_ROOT?.trim()
                    if (macWorkspaceRootOverride) {
                        runtimeOverrides.macSharedWorkspaceRoot = macWorkspaceRootOverride
                    }

                    String linuxWorkspaceRootOverride = params.LINUX_SHARED_WORKSPACE_ROOT?.trim()
                    if (linuxWorkspaceRootOverride) {
                        runtimeOverrides.linuxSharedWorkspaceRoot = linuxWorkspaceRootOverride
                    }

                    unrealPipelineFromProjectConfig(
                        bootstrapAgentLabel: 'windows && unreal && lightweight',
                        projectConfigPath: '.jenkins/config.groovy',
                        configOverrides: runtimeOverrides
                    )
                }
            }
        }
    }
}
