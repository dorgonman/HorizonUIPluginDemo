// .jenkins/Build/UGSBuild.Jenkinsfile
// Thin consumer entrypoint for the UGSBuild config.

@Library('jenkins-unreal-pipeline-library') _

pipeline {
    agent { label 'built-in' }

    options {
        skipDefaultCheckout(true)
    }

    parameters {
        string name: 'BUILD_BRANCH', defaultValue: 'main', description: 'Git branch to build (for example: main or release/5.7)'
        booleanParam(name: 'bBuildUGSStageWin64', defaultValue: true, description: 'Run UGS stage for Win64 (produces aggregatable artifacts)')
        booleanParam(name: 'bBuildUGSStageMac', defaultValue: true, description: 'Run UGS stage for Mac (produces aggregatable artifacts)')
        booleanParam(name: 'bBuildUGSStageLinux', defaultValue: false, description: 'Run UGS stage for Linux (produces aggregatable artifacts)')
        booleanParam(name: 'bInstallPrerequisites', defaultValue: false, description: 'Install prerequisites on each selected build agent before UGS staging')
        booleanParam(name: 'bCreateNuGetPackage', defaultValue: true, description: 'Create a NuGet package from aggregated UGS artifacts')
        booleanParam(name: 'bPrepareNuGetPackage', defaultValue: true, description: 'Prepare NuGet package inputs during aggregate without publishing')
        booleanParam(name: 'bDeployNuGetPackage', defaultValue: false, description: 'Push prepared NuGet packages to the configured feed')
        string name: 'NUGET_FEED_URL', defaultValue: 'https://api.nuget.org/v3/index.json', description: 'NuGet feed URL used when bDeployNuGetPackage is enabled'
        booleanParam(name: 'bDeployUnrealHordeServer', defaultValue: false, description: 'Deploy prepared UGS artifacts to Unreal Horde Server when implemented')
        string name: 'HORDE_SERVER_URL', defaultValue: 'http://unrealhorde.local/', description: 'Unreal Horde Server URL for UGS deploy metadata'
        string name: 'WIN64_SHARED_WORKSPACE_ROOT', defaultValue: '', description: 'Override Win64 shared workspace root. Empty uses config.groovy.'
        string name: 'MAC_SHARED_WORKSPACE_ROOT', defaultValue: '', description: 'Override Mac shared workspace root. Empty uses config.groovy.'
        string name: 'LINUX_SHARED_WORKSPACE_ROOT', defaultValue: '', description: 'Override Linux shared workspace root. Empty uses config.groovy.'
    }

    stages {
        stage('UGS Pipeline') {
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
                        workspaceSlot: 'UGSBuild',
                        win64SharedWorkspaceRoot: 'C:/_agent/_jenkins/agent/workspace/HorizonPlugin',
                        macSharedWorkspaceRoot: '/Users/Shared/jenkins/agent/workspace/HorizonPlugin',
                        linuxSharedWorkspaceRoot: '/var/jenkins/home/ws/HorizonPlugin',
                        buildArchiveRoot: 'Intermediate/BuildArchive',
                        buildPackageRoot: 'Intermediate/BuildPackage',
                        buildPluginRoot: 'Intermediate/BuildPlugin',
                        buildUgsRoot: 'Intermediate/BuildUGS',
                        nugetOutputDir: 'Intermediate/BuildUGS/NuGet',
                        aggregateAgentLabel: 'unreal-win64',
                        deployWorkspace: '',
                        bRunBuildGraphAggregation: false,
                        bRunTestStandaloneWin64: false,
                        coverageFormat: ['xml', 'html'],
                        pluginName: 'HorizonUIPlugin',
                        projectName: 'HorizonUIPluginDemo',
                        uprojectPath: 'HorizonUIPluginDemo.uproject',
                        nugetFeed: 'https://api.nuget.org/v3/index.json',
                        unrealHordeServer: 'http://unrealhorde.local/',
                        bSkipOrchestratorCheckout: true,
                    ]
                    def config = unrealConfig(cfg + [
                        bRunBuildPhase: true,
                        bRunAggregatePhase: true,
                        bRunPrepareDeployPhase: false,
                        bRunDeployPhase: false,
                        bBuildStandaloneWin64: false,
                        bBuildPluginWin64: false,
                        bBuildStandaloneMac: false,
                        bBuildStandaloneLinux: false,
                        bBuildUGSStage: true,
                        bBuildUGSStageWin64: params.bBuildUGSStageWin64,
                        bBuildUGSStageMac: params.bBuildUGSStageMac,
                        bBuildUGSStageLinux: params.bBuildUGSStageLinux,
                        buildBranch: params.BUILD_BRANCH?.trim() ?: 'main',
                        bInstallPrerequisites: params.bInstallPrerequisites,
                        bCreateNuGetPackage: params.bCreateNuGetPackage,
                        bPrepareNuGetPackage: params.bPrepareNuGetPackage || params.bCreateNuGetPackage || params.bDeployNuGetPackage,
                        bDeployNuGetPackage: params.bDeployNuGetPackage,
                        bDeployPerforce: false,
                        bRunTestStandaloneWin64: false,
                        bDeployUnrealHordeServer: params.bDeployUnrealHordeServer,
                        nugetFeed: params.NUGET_FEED_URL?.trim() ?: cfg.nugetFeed,
                        unrealHordeServer: params.HORDE_SERVER_URL?.trim() ?: cfg.unrealHordeServer,
                        buildConfiguration: 'UGSBuild',
                        workspaceSlot: "UGSBuild",
                        win64SharedWorkspaceRoot: params.WIN64_SHARED_WORKSPACE_ROOT?.trim() ?: cfg.win64SharedWorkspaceRoot,
                        macSharedWorkspaceRoot: params.MAC_SHARED_WORKSPACE_ROOT?.trim() ?: cfg.macSharedWorkspaceRoot,
                        linuxSharedWorkspaceRoot: params.LINUX_SHARED_WORKSPACE_ROOT?.trim() ?: cfg.linuxSharedWorkspaceRoot,
                    ])
                    unrealPipeline(config)
                }
            }
        }
    }
}
