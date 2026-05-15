// .jenkins/Build/UGSBuild.Jenkinsfile
// Thin consumer entrypoint for shared UGSBuild orchestration.

@Library('kano-jenkins-unreal-pipeline-library') _

// Azure DevOps may require credential.useHttpPath=true when multiple repos share
// the same host with different credentials. Keep this scoped to this Pipeline run.
env.GIT_CONFIG_COUNT = '1'
env.GIT_CONFIG_KEY_0 = 'credential.useHttpPath'
env.GIT_CONFIG_VALUE_0 = 'true'

unrealUgsBuildPipeline(
    projectConfigPath: '.jenkins/config.groovy',
    configOverrides: [
        // Job-specific toggle only; agent routing comes from .jenkins/config.groovy capability labels.
        bDeployUnrealHordeServer: true,
    ]
)
