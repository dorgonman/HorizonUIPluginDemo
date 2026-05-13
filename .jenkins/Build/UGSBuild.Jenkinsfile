// .jenkins/Build/UGSBuild.Jenkinsfile
// Thin consumer entrypoint for shared UGSBuild orchestration.

@Library('jenkins-unreal-pipeline-library') _

env.GIT_CONFIG_COUNT = '1'
env.GIT_CONFIG_KEY_0 = 'credential.useHttpPath'
env.GIT_CONFIG_VALUE_0 = 'true'

properties([
    parameters([
        booleanParam(name: 'bDeploySentrySymbols', defaultValue: true, description: 'After standalone builds, create Sentry release/deploy records and upload debug symbols'),
        booleanParam(name: 'bDeploySentryForeignUnrealEngineSymbols', defaultValue: false, description: 'Also upload Unreal Engine editor symbols to SENTRY_FOREIGN_PROJECT'),
        booleanParam(name: 'bDeploySentryBundleSources', defaultValue: true, description: 'Run sentry-cli difutil bundle-sources and upload source context with debug symbols. Enable only for projects allowed to upload source code.'),
        string(name: 'SENTRY_CREDENTIAL_ID', defaultValue: 'SENTRY_AUTH_INFO', description: 'Jenkins username/password credential: username=SENTRY_URL, password=SENTRY_AUTH_TOKEN'),
        string(name: 'SENTRY_ORG', defaultValue: 'kanohorizonia', description: 'Sentry organization slug for this project'),
        string(name: 'SENTRY_PROJECT', defaultValue: 'horizonuiplugindemo', description: 'Sentry project slug for this project'),
        string(name: 'SENTRY_FOREIGN_PROJECT', defaultValue: 'unrealengine', description: 'Separate Sentry project slug for foreign symbols such as Unreal Engine PDBs'),
        string(name: 'SENTRY_ENVIRONMENT', defaultValue: 'dev', description: 'Sentry deploy environment name'),
    ])
])

def configLoader = load '.jenkins/config.groovy'
def cfg = configLoader.projectConfig() + [
    // UGS aggregate and NuGet stages share a Deploy workspace; keep Windows work on one node.
    windowsAgentLabel: 'pc-dorgonchang-rtx3090.local',
    win64UgsAgentLabel: 'pc-dorgonchang-rtx3090.local',
    aggregateAgentLabel: 'pc-dorgonchang-rtx3090.local',
    bDeployUnrealHordeServer: true,
]


// NOTE: Jenkins job XML may be missing <defaultValue> for SENTRY_* params even
// when the Groovy file specifies them. This can cause Jenkins to pass null or ""
// for these parameters on every build, silently overriding cfg defaults.
// The explicit " ?: cfg.X" fallback below guards against this by preferring
// cfg defaults when the Jenkins-supplied value is null/empty/blank.
def resolvedParams = [
    bDeploySentrySymbols:              params.bDeploySentrySymbols,
    bDeploySentryForeignUnrealEngineSymbols: params.bDeploySentryForeignUnrealEngineSymbols,
    bDeploySentryBundleSources:        params.bDeploySentryBundleSources,
    sentryCredentialId:                params.SENTRY_CREDENTIAL_ID?.trim() ?: cfg.sentryCredentialId,
    sentryOrg:                         params.SENTRY_ORG?.trim() ?: cfg.sentryOrg,
    sentryProject:                     params.SENTRY_PROJECT?.trim() ?: cfg.sentryProject,
    sentryForeignProject:              params.SENTRY_FOREIGN_PROJECT?.trim() ?: cfg.sentryForeignProject,
    sentryEnvironment:                params.SENTRY_ENVIRONMENT?.trim() ?: cfg.sentryEnvironment,
]
// Boolean params: Jenkins passes null when no defaultValue is set in the job XML.
// When null, fall back to cfg default (which is the authoritative value).
resolvedParams.bDeploySentrySymbols              = resolvedParams.bDeploySentrySymbols              ?: cfg.bDeploySentrySymbols
resolvedParams.bDeploySentryForeignUnrealEngineSymbols = resolvedParams.bDeploySentryForeignUnrealEngineSymbols ?: cfg.bDeploySentryForeignUnrealEngineSymbols
resolvedParams.bDeploySentryBundleSources         = resolvedParams.bDeploySentryBundleSources         ?: cfg.bDeploySentryBundleSources

def config = unrealConfig(cfg + resolvedParams)

unrealUgsBuildPipeline(config: config)
