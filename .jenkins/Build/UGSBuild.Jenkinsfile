// .jenkins/Build/UGSBuild.Jenkinsfile
// Thin consumer entrypoint for shared UGSBuild orchestration.

@Library('kano-jenkins-unreal-pipeline-library') _

pipeline {
    agent none

    options {
        skipDefaultCheckout(true)
    }

    parameters {
        booleanParam name: 'bFailFast', defaultValue: true, description: 'Abort sibling parallel branches in the same fan-out when one branch fails.'
        booleanParam name: 'bCleanSCM', defaultValue: false, description: 'Run git checkout -f -- . && git clean -ddfx . to wipe all unstaged changes before building (also applies to submodules)'
        booleanParam name: 'bDeployUnrealHordeServer', defaultValue: true, description: 'Allow UGSBuild to upload Horde artifacts'
    }

    stages {
        stage('UGS Build') {
            steps {
                script {
                    // Azure DevOps may require credential.useHttpPath=true when multiple repos share
                    // the same host with different credentials. Keep this scoped to this Pipeline run.
                    env.GIT_CONFIG_COUNT = '1'
                    env.GIT_CONFIG_KEY_0 = 'credential.useHttpPath'
                    env.GIT_CONFIG_VALUE_0 = 'true'

                    unrealUgsBuildPipeline(
                        projectConfigPath: '.jenkins/config.groovy',
                        configOverrides: [
                            // Job-specific toggles only; agent routing comes from .jenkins/config.groovy capability labels.
                            bCleanSCM: params.bCleanSCM,
                            bDeployUnrealHordeServer: params.bDeployUnrealHordeServer,
                            bFailFast: params.bFailFast,
                        ]
                    )
                }
            }
        }
    }
}
