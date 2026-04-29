// .jenkins/Build/UGSBuild.Jenkinsfile
// Project-owned UGS pipeline entrypoint.
//
// This job intentionally does not call the shared unrealPipeline() UGS orchestration:
// the shared path wraps producer outputs under Staging/<Platform>, creates test/coverage
// report folders for non-test UGS stages, and can invoke the Mac producer twice.  UGS
// staging artifacts are already platform-partitioned below Binaries/ and Plugins/, so the
// aggregate workspace should merge producer stashes directly at ArchiveForUGS/Staging/.

pipeline {
    agent { label 'built-in' }

    options {
        skipDefaultCheckout(true)
        disableConcurrentBuilds()
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
        stage('Build UGS PCB Producers') {
            steps {
                script {
                    def branchName = params.BUILD_BRANCH?.trim() ?: 'main'
                    def win64Root = params.WIN64_SHARED_WORKSPACE_ROOT?.trim() ?: 'C:/_agent/_jenkins/agent/workspace/HorizonPlugin'
                    def macRoot = params.MAC_SHARED_WORKSPACE_ROOT?.trim() ?: '/Users/Shared/jenkins/agent/workspace/HorizonPlugin'
                    def linuxRoot = params.LINUX_SHARED_WORKSPACE_ROOT?.trim() ?: '/var/jenkins/home/ws/HorizonPlugin'
                    def producers = [:]

                    if (params.bBuildUGSStageWin64) {
                        producers['Win64-UGS'] = {
                            node('unreal-win64') {
                                ws("${win64Root}/HorizonUIPluginDemo/UGSBuild") {
                                    cleanWs()
                                    checkout scm
                                    bat "bash -lc \"git fetch origin '+refs/heads/*:refs/remotes/origin/*' && git checkout -B '${branchName}' 'origin/${branchName}' && git submodule update --init --recursive\""
                                    bat "bash -lc \"rm -rf './Intermediate/BuildUGS/ArchiveForUGS/Staging'\""
                                    withEnv(["UGS_BRANCH=${branchName}"]) {
                                        bat "bash -lc \"cd 'Build/Base' && pixi run ugs-stage\""
                                    }
                                    dir('Intermediate/BuildUGS') {
                                        archiveArtifacts artifacts: 'ArchiveForUGS/Staging/**', fingerprint: true, allowEmptyArchive: false
                                    }
                                    stash name: 'win64-ugs-artifacts', includes: 'Intermediate/BuildUGS/ArchiveForUGS/Staging/**', useDefaultExcludes: false
                                }
                            }
                        }
                    }

                    if (params.bBuildUGSStageMac) {
                        producers['Mac-UGS'] = {
                            node('unreal-mac') {
                                ws("${macRoot}/HorizonUIPluginDemo/UGSBuild") {
                                    cleanWs()
                                    checkout scm
                                    sh "git fetch origin '+refs/heads/*:refs/remotes/origin/*' && git checkout -B '${branchName}' 'origin/${branchName}' && git submodule update --init --recursive"
                                    sh "rm -rf './Intermediate/BuildUGS/ArchiveForUGS/Staging'"
                                    withEnv(["UGS_BRANCH=${branchName}", 'PATH=/Users/dorgon.chang/.pixi/bin:/Users/dorgon.chang/.local/bin:/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin']) {
                                        sh "cd 'Build/Base' && pixi run ugs-stage"
                                    }
                                    dir('Intermediate/BuildUGS') {
                                        archiveArtifacts artifacts: 'ArchiveForUGS/Staging/**', fingerprint: true, allowEmptyArchive: false
                                    }
                                    stash name: 'mac-ugs-artifacts', includes: 'Intermediate/BuildUGS/ArchiveForUGS/Staging/**', useDefaultExcludes: false
                                }
                            }
                        }
                    }

                    if (params.bBuildUGSStageLinux) {
                        producers['Linux-UGS'] = {
                            node('unreal-linux') {
                                ws("${linuxRoot}/HorizonUIPluginDemo/UGSBuild") {
                                    cleanWs()
                                    checkout scm
                                    sh "git fetch origin '+refs/heads/*:refs/remotes/origin/*' && git checkout -B '${branchName}' 'origin/${branchName}' && git submodule update --init --recursive"
                                    sh "rm -rf './Intermediate/BuildUGS/ArchiveForUGS/Staging'"
                                    withEnv(["UGS_BRANCH=${branchName}"]) {
                                        sh "cd 'Build/Base' && pixi run ugs-stage"
                                    }
                                    dir('Intermediate/BuildUGS') {
                                        archiveArtifacts artifacts: 'ArchiveForUGS/Staging/**', fingerprint: true, allowEmptyArchive: false
                                    }
                                    stash name: 'linux-ugs-artifacts', includes: 'Intermediate/BuildUGS/ArchiveForUGS/Staging/**', useDefaultExcludes: false
                                }
                            }
                        }
                    }

                    if (producers.isEmpty()) {
                        error('Select at least one UGS producer platform.')
                    }

                    parallel producers
                }
            }
        }

        stage('Aggregate') {
            agent { label 'unreal-win64' }
            steps {
                script {
                    def branchName = params.BUILD_BRANCH?.trim() ?: 'main'
                    def win64Root = params.WIN64_SHARED_WORKSPACE_ROOT?.trim() ?: 'C:/_agent/_jenkins/agent/workspace/HorizonPlugin'
                    ws("${win64Root}/HorizonUIPluginDemo/Deploy") {
                        cleanWs()
                        checkout scm
                        bat "bash -lc \"git fetch origin '+refs/heads/*:refs/remotes/origin/*' && git checkout -B '${branchName}' 'origin/${branchName}' && git submodule update --init --recursive\""

                        if (params.bBuildUGSStageWin64) {
                            unstash 'win64-ugs-artifacts'
                        }
                        if (params.bBuildUGSStageMac) {
                            unstash 'mac-ugs-artifacts'
                        }
                        if (params.bBuildUGSStageLinux) {
                            unstash 'linux-ugs-artifacts'
                        }

                        if (params.bCreateNuGetPackage || params.bPrepareNuGetPackage || params.bDeployNuGetPackage) {
                            withEnv([
                                "UGS_BRANCH=${branchName}",
                                "UGS_PREBUILT_ARCHIVE_STAGING_DIR=${pwd()}/Intermediate/BuildUGS/ArchiveForUGS/Staging",
                                "UGS_NUGET_OUTPUT_DIR=${pwd()}/Intermediate/BuildUGS/NuGet",
                                "UGS_NUGET_SOURCE=${params.NUGET_FEED_URL?.trim() ?: 'https://api.nuget.org/v3/index.json'}"
                            ]) {
                                bat "bash -lc \"mkdir -p 'Intermediate/BuildUGS/NuGet' && cd 'Build/Base' && pixi run ugs-nuget-pack\""
                            }
                        }

                        if (params.bDeployNuGetPackage) {
                            withEnv([
                                "UGS_BRANCH=${branchName}",
                                "UGS_PREBUILT_ARCHIVE_STAGING_DIR=${pwd()}/Intermediate/BuildUGS/ArchiveForUGS/Staging",
                                "UGS_NUGET_OUTPUT_DIR=${pwd()}/Intermediate/BuildUGS/NuGet",
                                "UGS_NUGET_SOURCE=${params.NUGET_FEED_URL?.trim() ?: 'https://api.nuget.org/v3/index.json'}"
                            ]) {
                                bat "bash -lc \"cd 'Build/Base' && pixi run ugs-nuget-push\""
                            }
                        }

                        archiveArtifacts artifacts: 'Intermediate/BuildUGS/**', fingerprint: true, allowEmptyArchive: false
                    }
                }
            }
        }
    }
}
