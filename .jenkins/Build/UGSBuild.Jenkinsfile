// .jenkins/Build/UGSBuild.Jenkinsfile
// Thin consumer entrypoint for shared UGSBuild orchestration.

@Library('jenkins-unreal-pipeline-library') _

env.GIT_CONFIG_COUNT = '1'
env.GIT_CONFIG_KEY_0 = 'credential.useHttpPath'
env.GIT_CONFIG_VALUE_0 = 'true'

properties([
    parameters([
        booleanParam(name: 'bDeploySentrySymbols', defaultValue: true, description: 'After standalone builds, create Sentry release/deploy records and upload debug symbols'),
        booleanParam(name: 'bDeploySentryForeignSymbols', defaultValue: true, description: 'Also upload foreign symbols such as Unreal Engine PDBs to SENTRY_FOREIGN_PROJECT'),
        booleanParam(name: 'bDeploySentryBundleSources', defaultValue: true, description: 'Run sentry-cli difutil bundle-sources and upload source context with debug symbols. Enable only for projects allowed to upload source code.'),
        string(name: 'SENTRY_CREDENTIAL_ID', defaultValue: 'SENTRY_AUTH_INFO', description: 'Jenkins username/password credential: username=SENTRY_URL, password=SENTRY_AUTH_TOKEN'),
        string(name: 'SENTRY_ORG', defaultValue: 'kanohorizonia', description: 'Sentry organization slug for this project'),
        string(name: 'SENTRY_PROJECT', defaultValue: 'horizonuiplugindemo', description: 'Sentry project slug for this project'),
        string(name: 'SENTRY_FOREIGN_PROJECT', defaultValue: 'unrealengine', description: 'Separate Sentry project slug for foreign symbols such as Unreal Engine PDBs'),
        string(name: 'SENTRY_ENVIRONMENT', defaultValue: 'dev', description: 'Sentry deploy environment name'),
    ])
])

def cfg = [
    projectRoot: '.',
    sharedLibraryName: 'jenkins-unreal-pipeline-library',
    // UGS aggregate and NuGet stages share a Deploy workspace; keep Windows work on one node.
    windowsAgentLabel: 'pc-dorgonchang-rtx3090.local',
    macAgentLabel: 'unreal-mac',
    linuxAgentLabel: 'unreal-linux',
    win64StandaloneAgentLabel: '',
    macStandaloneAgentLabel: '',
    linuxStandaloneAgentLabel: '',
    win64UgsAgentLabel: 'pc-dorgonchang-rtx3090.local',
    macUgsAgentLabel: '',
    linuxUgsAgentLabel: '',
    scriptRoot: 'Build',
    reportRoot: 'Intermediate/BuildPackage',
    slug: 'HorizonUIPluginDemo',
    workspaceSlot: 'Package',
    win64SharedWorkspaceRoot: 'C:/_agent/_jenkins/agent/workspace/HorizonPlugin',
    macSharedWorkspaceRoot: '/Users/Shared/jenkins/agent/workspace/HorizonPlugin',
    linuxSharedWorkspaceRoot: '/var/jenkins/home/ws/HorizonPlugin',
    buildArchiveArtifactRoot: 'Intermediate/BuildArchive',
    buildPackageArtifactRoot: 'Intermediate/BuildPackage',
    buildPluginArtifactRoot: 'Intermediate/BuildPlugin',
    buildUgsArtifactRoot: 'Intermediate/BuildUGS',
    bCleanSCM: false,
    bBuildStandaloneWin64: true,
    bBuildServerWin64: false,
    bBuildPluginWin64: true,
    bBuildStandaloneAndroid: false,
    bBuildServerAndroid: false,
    bBuildStandaloneMac: false,
    bBuildServerMac: false,
    bBuildStandaloneLinux: false,
    bBuildServerLinux: false,
    bBuildStandaloneIOS: false,
    bBuildServerIOS: false,
    bBuildStandaloneXSX: false,
    bBuildServerXSX: false,
    bBuildStandalonePS5: false,
    bBuildServerPS5: false,
    bBuildStandaloneSwitch2: false,
    bBuildServerSwitch2: false,
    bRunBuildPhase: true,
    bRunAggregatePhase: false,
    bRunPrepareDeployPhase: false,
    bRunDeployPhase: false,
    bPrepareNuGetPackage: false,
    bDeployNuGetPackage: false,
    bDeployPerforce: false,
    nugetFeed: 'https://api.nuget.org/v3/index.json',
    aggregateAgentLabel: 'pc-dorgonchang-rtx3090.local',
    deployWorkspace: '',
    bRunBuildGraphAggregation: false,
    bRunTestStandaloneWin64: true,
    coverageFormat: ['xml', 'html'],
    buildConfiguration: 'Development',
    bDeploySentrySymbols: true,
    bCopyPreCompileEngine: true,
    preArchiveCopyStep: 'Default',
    sentryCredentialId: 'SENTRY_AUTH_INFO',
    sentryOrg: 'kanohorizonia',
    sentryProject: 'horizonuiplugindemo',
    sentryForeignProject: 'unrealengine',
    sentryEnvironment: 'dev',
    bUploadToUnrealHordeServer: false,
    bDeployUnrealHordeServer: false,
    unrealHordeServer: 'http://unrealhorde.local/',
    hordeToken: '',
    hordeGitStreamRepo: 'https://dev.azure.com/kanohorizonia/UEHorizonPlugin/_git/HorizonUIPluginDemo',
    pluginName: 'HorizonUIPlugin',
    projectName: 'HorizonUIPluginDemo',
    uprojectPath: 'HorizonUIPluginDemo.uproject',
]

def config = unrealConfig(cfg + [
    bDeploySentrySymbols: params.bDeploySentrySymbols,
    bDeploySentryForeignSymbols: params.bDeploySentryForeignSymbols,
    bDeploySentryBundleSources: params.bDeploySentryBundleSources,
    sentryCredentialId: params.SENTRY_CREDENTIAL_ID?.trim() ?: cfg.sentryCredentialId,
    sentryOrg: params.SENTRY_ORG?.trim() ?: cfg.sentryOrg,
    sentryProject: params.SENTRY_PROJECT?.trim() ?: cfg.sentryProject,
    sentryForeignProject: params.SENTRY_FOREIGN_PROJECT?.trim() ?: cfg.sentryForeignProject,
    sentryEnvironment: params.SENTRY_ENVIRONMENT?.trim() ?: cfg.sentryEnvironment,
])

unrealUgsBuildPipeline(config: config)
