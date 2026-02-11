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
        // booleanParam name: 'bBuildServerWin64', defaultValue: false, description: 'Build Win64 server target'
        booleanParam name: 'bBuildStandaloneAndroid', defaultValue: true, description: 'Build Android standalone target'
        // booleanParam name: 'bBuildStandaloneIOS', defaultValue: false, description: 'Build iOS standalone target (requires Mac agent + Apple Developer Plan)'
        // booleanParam name: 'bBuildStandaloneMac', defaultValue: false, description: 'Build Mac standalone target (requires Mac agent + Apple Developer Plan)'
        // booleanParam name: 'bBuildServerMac', defaultValue: false, description: 'Build Mac server target (requires Mac agent + Apple Developer Plan)'
        // booleanParam name: 'bBuildStandaloneXSX', defaultValue: false, description: 'Build Xbox Series X standalone target'
        // booleanParam name: 'bBuildStandalonePS5', defaultValue: false, description: 'Build PlayStation 5 standalone target'
        // booleanParam name: 'bBuildStandaloneSwitch2', defaultValue: false, description: 'Build Nintendo Switch 2 standalone target'
        // booleanParam name: 'bBuildStandaloneLinux', defaultValue: false, description: 'Build Linux standalone target'
        // booleanParam name: 'bBuildServerLinux', defaultValue: false, description: 'Build Linux server target'

        // === Plugin Booleans ===
        booleanParam name: 'bBuildPluginWin64', defaultValue: true, description: 'Build Win64 Plugin Shipping'
        // booleanParam name: 'bBuildPluginAndroid', defaultValue: false, description: 'Build Android Plugin Shipping'
        booleanParam name: 'bBuildPluginIOS', defaultValue: true, description: 'Build iOS Plugin Shipping (requires Mac agent + Apple Developer Plan)'
        booleanParam name: 'bBuildPluginMac', defaultValue: true, description: 'Build Mac Plugin Shipping (requires Mac agent + Apple Developer Plan)'
        // booleanParam name: 'bBuildPluginXSX', defaultValue: false, description: 'Build Xbox Series X Plugin Shipping'
        // booleanParam name: 'bBuildPluginPS5', defaultValue: false, description: 'Build PS5 Plugin Shipping'
        // booleanParam name: 'bBuildPluginSwitch2', defaultValue: false, description: 'Build Switch 2 Plugin Shipping'
        booleanParam name: 'bBuildPluginLinux', defaultValue: false, description: 'Build Linux Plugin Shipping'

        // === Test ===
        booleanParam name: 'bRunTestStandaloneWin64', defaultValue: true, description: 'Run Win64 standalone tests'

        // === Prerequisites ===
        booleanParam name: 'bInstallPrerequisites', defaultValue: true, description: 'Install prerequisites before building (runs Build/Base/install-prerequisites.sh)'

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
                        reportRoot: 'Intermediate/BuildArchive/Reports',
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
                        bBuildPluginWin64: params.bBuildPluginWin64,
                        bBuildPluginIOS: params.bBuildPluginIOS,
                        bBuildPluginMac: params.bBuildPluginMac,
                        bBuildPluginLinux: params.bBuildPluginLinux,
                        bRunTestStandaloneWin64: params.bRunTestStandaloneWin64,
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
