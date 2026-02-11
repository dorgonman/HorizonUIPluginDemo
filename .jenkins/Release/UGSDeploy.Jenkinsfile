// .jenkins/Build/UGSDeploy.Jenkinsfile
// Dedicated deploy workspace that aggregates UGS artifacts from all platforms.
// Runs after UGSBuild completes on all platforms.

@Library('jenkins-unreal-pipeline-library') _

def sharedWorkspaceRoot = 'C:/_agent/_jenkins/agent/workspace'

pipeline {
    parameters {
        // Source build job name - adjust to match your Jenkins job name for UGSBuild
        string(name: 'UGS_BUILD_JOB_NAME', defaultValue: 'HorizonUIPluginDemo-UGSBuild', description: 'Name of the UGS build job to copy artifacts from')
        // Build numbers to copy from (leave empty for latest)
        string(name: 'WIN64_BUILD_NUMBER', defaultValue: '', description: 'Win64 build number to copy (empty = latest)')
        string(name: 'MAC_BUILD_NUMBER', defaultValue: '', description: 'Mac build number to copy (empty = latest)')
        string(name: 'LINUX_BUILD_NUMBER', defaultValue: '', description: 'Linux build number to copy (empty = latest)')
        // NuGet deployment options
        booleanParam(name: 'bDeployNuGetPackage', defaultValue: false, description: 'Deploy to NuGet.org')
        string(name: 'NUGET_API_KEY', defaultValue: '', description: 'NuGet API key (use Jenkins credential binding)')
        // Horde deployment options
        booleanParam(name: 'bDeployUnrealHordeServer', defaultValue: false, description: 'Deploy to Unreal Horde Server')
        string(name: 'HORDE_SERVER_URL', defaultValue: 'http://unrealhorde.local/', description: 'Unreal Horde Server URL')
        // Perforce deployment options
        booleanParam(name: 'bDeployPerforce', defaultValue: false, description: 'Deploy to Perforce')
    }

    agent {
        node {
            label 'unreal-win64'
            customWorkspace "${sharedWorkspaceRoot}/HorizonPlugin/HorizonUIPluginDemo/Deploy"
        }
    }

    stages {
        stage('Copy UGS Artifacts') {
            steps {
                script {
                    def configLoader = load '.jenkins/config.groovy'
                    def cfg = configLoader.projectConfig()

                    // Copy archived UGS artifacts from the UGSBuild job
                    // Aggregation already happened within UGSBuild (Win64 agent receives Mac/Linux via stash)
                    copyArtifacts(projectName: params.UGS_BUILD_JOB_NAME, filter: '**/Intermediate/BuildUGS/**', 
                                   selector: lastSuccessful(), fingerprint: true, allowEmpty: true)
                    
                    echo "Copied UGS artifacts from ${params.UGS_BUILD_JOB_NAME}"
                }
            }
        }

        stage('Prepare Deploy') {
            steps {
                script {
                    def configLoader = load '.jenkins/config.groovy'
                    def cfg = configLoader.projectConfig()

                    def config = unrealConfig(cfg + [
                        bRunBuildPhase: false,
                        bRunPrepareDeployPhase: true,
                        bRunDeployPhase: false,
                        bBuildStandaloneWin64: false,
                        bBuildServerWin64: false,
                        bBuildPluginWin64: false,
                        bBuildStandaloneAndroid: false,
                        bBuildServerAndroid: false,
                        bBuildPluginAndroid: false,
                        bBuildStandaloneIOS: false,
                        bBuildServerIOS: false,
                        bBuildPluginIOS: false,
                        bBuildStandaloneMac: false,
                        bBuildServerMac: false,
                        bBuildPluginMac: false,
                        bBuildStandaloneXSX: false,
                        bBuildServerXSX: false,
                        bBuildPluginXSX: false,
                        bBuildStandalonePS5: false,
                        bBuildServerPS5: false,
                        bBuildPluginPS5: false,
                        bBuildStandaloneSwitch2: false,
                        bBuildServerSwitch2: false,
                        bBuildPluginSwitch2: false,
                        bBuildStandaloneLinux: false,
                        bBuildServerLinux: false,
                        bBuildPluginLinux: false,
                        bBuildUGSStage: false,
                        bBuildUGSStageWin64: false,
                        bBuildUGSStageMac: false,
                        bBuildUGSStageLinux: false,
                        bCreateNuGetPackage: false,
                        bPrepareNuGetPackage: true,
                        bDeployNuGetPackage: params.bDeployNuGetPackage,
                        bDeployPerforce: params.bDeployPerforce,
                        bRunTestStandaloneWin64: false,
                        bDeployUnrealHordeServer: params.bDeployUnrealHordeServer,
                        unrealHordeServer: params.HORDE_SERVER_URL ?: 'http://unrealhorde.local/',
                        buildConfiguration: 'UGSBuild',
                        nugetApiKey: params.NUGET_API_KEY ?: '',
                    ])

                    // Inject nugetApiKey from config (should use Jenkins credentials in production)
                    config.nugetApiKey = params.NUGET_API_KEY ?: ''

                    unrealPipeline(config)
                }
            }
        }

        stage('Deploy') {
            when {
                expression { return params.bDeployNuGetPackage || params.bDeployUnrealHordeServer || params.bDeployPerforce }
            }
            steps {
                script {
                    def configLoader = load '.jenkins/config.groovy'
                    def cfg = configLoader.projectConfig()

                    def config = unrealConfig(cfg + [
                        bRunBuildPhase: false,
                        bRunPrepareDeployPhase: false,
                        bRunDeployPhase: true,
                        bBuildStandaloneWin64: false,
                        bBuildServerWin64: false,
                        bBuildPluginWin64: false,
                        bBuildStandaloneAndroid: false,
                        bBuildServerAndroid: false,
                        bBuildPluginAndroid: false,
                        bBuildStandaloneIOS: false,
                        bBuildServerIOS: false,
                        bBuildPluginIOS: false,
                        bBuildStandaloneMac: false,
                        bBuildServerMac: false,
                        bBuildPluginMac: false,
                        bBuildStandaloneXSX: false,
                        bBuildServerXSX: false,
                        bBuildPluginXSX: false,
                        bBuildStandalonePS5: false,
                        bBuildServerPS5: false,
                        bBuildPluginPS5: false,
                        bBuildStandaloneSwitch2: false,
                        bBuildServerSwitch2: false,
                        bBuildPluginSwitch2: false,
                        bBuildStandaloneLinux: false,
                        bBuildServerLinux: false,
                        bBuildPluginLinux: false,
                        bBuildUGSStage: false,
                        bBuildUGSStageWin64: false,
                        bBuildUGSStageMac: false,
                        bBuildUGSStageLinux: false,
                        bCreateNuGetPackage: false,
                        bPrepareNuGetPackage: false,
                        bDeployNuGetPackage: params.bDeployNuGetPackage,
                        bDeployPerforce: params.bDeployPerforce,
                        bRunTestStandaloneWin64: false,
                        bDeployUnrealHordeServer: params.bDeployUnrealHordeServer,
                        unrealHordeServer: params.HORDE_SERVER_URL ?: 'http://unrealhorde.local/',
                        buildConfiguration: 'UGSBuild',
                        nugetApiKey: params.NUGET_API_KEY ?: '',
                    ])

                    config.nugetApiKey = params.NUGET_API_KEY ?: ''

                    unrealPipeline(config)
                }
            }
        }
    }

    post {
        always {
            echo 'UGS Deploy pipeline completed'
        }
    }
}
