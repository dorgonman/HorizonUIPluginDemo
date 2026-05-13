// .jenkins/Build/UGSBuild.Jenkinsfile
// Thin consumer entrypoint for shared UGSBuild orchestration.

@Library('jenkins-unreal-pipeline-library') _

// Azure DevOps may require credential.useHttpPath=true when multiple repos share
// the same host with different credentials. Keep this scoped to this Pipeline run.
env.GIT_CONFIG_COUNT = '1'
env.GIT_CONFIG_KEY_0 = 'credential.useHttpPath'
env.GIT_CONFIG_VALUE_0 = 'true'

unrealUgsBuildPipeline(
    projectConfigPath: '.jenkins/config.groovy',
    configOverrides: [
        // UGS aggregate and NuGet stages share a Deploy workspace; keep Windows work on one node.
        windowsAgentLabel: 'pc-dorgonchang-rtx3090.local',
        win64UgsAgentLabel: 'pc-dorgonchang-rtx3090.local',
        aggregateAgentLabel: 'pc-dorgonchang-rtx3090.local',
        bDeployUnrealHordeServer: true,
    ]
)
