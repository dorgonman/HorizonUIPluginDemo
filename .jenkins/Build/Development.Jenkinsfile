// .jenkins/Build/Development.Jenkinsfile
// Thin consumer entrypoint for the Development build config.

@Library('jenkins-unreal-pipeline-library') _

pipeline {
    environment {
        UNREAL_BUILD_MACHINE = '1'
    }

    agent { label 'built-in' }
    // Root orchestration uses Jenkins controller (built-in).
    // This does NOT consume a build agent executor slot.
    //
    // Platform branches inside unrealPipeline() use their own
    // node{} blocks with explicit platform labels, so they land
    // on the correct build agents (Windows/Mac/Linux).
    //
    // Using a build agent as root (e.g., 'unreal-win64') caused
    // executor starvation: root consumed 1 of 2 Windows executors
    // while appearing idle, leaving 0 free for the Windows build branch.
    //
    // 'built-in' = Jenkins controller node, separate from all
    // build agents, so no executor starvation.

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
                    def cfg = [
                        projectRoot: '.',
                        sharedLibraryName: 'jenkins-unreal-pipeline-library',
                        windowsAgentLabel: 'unreal-win64',
                        macAgentLabel: 'unreal-mac',
                        linuxAgentLabel: 'unreal-linux',
                        win64StandaloneAgentLabel: '',
                        macStandaloneAgentLabel: '',
                        linuxStandaloneAgentLabel: '',
                        win64UgsAgentLabel: '',
                        macUgsAgentLabel: '',
                        linuxUgsAgentLabel: '',
                        scriptRoot: 'Build',
                        reportRoot: 'Intermediate/BuildPackage',
                        slug: 'HorizonUIPluginDemo',
                        workspaceSlot: 'Package',
                        win64SharedWorkspaceRoot: 'C:/_agent/_jenkins/agent/workspace/HorizonPlugin',
                        macSharedWorkspaceRoot: '/Users/Shared/jenkins/agent/workspace/HorizonPlugin',
                        linuxSharedWorkspaceRoot: '/var/jenkins/home/ws/HorizonPlugin',
                        buildArchiveRoot: 'Intermediate/BuildArchive',
                        buildPackageRoot: 'Intermediate/BuildPackage',
                        buildPluginRoot: 'Intermediate/BuildPlugin',
                        buildUgsRoot: 'Intermediate/BuildUGS',
                        aggregateAgentLabel: 'unreal-win64',
                        deployWorkspace: '',
                        bRunBuildGraphAggregation: false,
                        coverageFormat: ['xml', 'html'],
                        pluginName: 'HorizonUIPlugin',
                        projectName: 'HorizonUIPluginDemo',
                        uprojectPath: 'HorizonUIPluginDemo.uproject',
                        nugetFeed: 'https://api.nuget.org/v3/index.json',
                        unrealHordeServer: 'http://unrealhorde.local/',
                        bSkipOrchestratorCheckout: true,
                    ]
                    def config = unrealConfig(cfg + [
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
                        bFailFast: params.bFailFast,
                        win64SharedWorkspaceRoot: params.WIN64_SHARED_WORKSPACE_ROOT?.trim() ?: cfg.win64SharedWorkspaceRoot,
                        macSharedWorkspaceRoot: params.MAC_SHARED_WORKSPACE_ROOT?.trim() ?: cfg.macSharedWorkspaceRoot,
                        linuxSharedWorkspaceRoot: params.LINUX_SHARED_WORKSPACE_ROOT?.trim() ?: cfg.linuxSharedWorkspaceRoot,
                        workspaceSlot: 'Package',
                        buildConfiguration: 'Development',
                    ])
                    unrealPipeline(config)
                }
            }
        }
    }
}
