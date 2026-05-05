// .jenkins/Build/UGSBuild.Jenkinsfile
// Thin consumer entrypoint for shared UGSBuild orchestration.

@Library('jenkins-unreal-pipeline-library') _

pipeline {
    environment {
        SENTRY_AUTH_INFO = credentials('SENTRY_AUTH_INFO')
        PATH+GIT_BASH = 'C:\\Program Files\\Git\\bin;C:\\Program Files\\Git\\usr\\bin'
    }

    agent { label 'built-in' }

    options {
        skipDefaultCheckout(true)
    }

    parameters {
        // === Sentry Deploy Symbols ===
        booleanParam name: 'bDeploySentrySymbols', defaultValue: true, description: 'After standalone builds, create Sentry release/deploy records and upload debug symbols'
        booleanParam name: 'bDeploySentryForeignSymbols', defaultValue: true, description: 'Also upload foreign symbols such as Unreal Engine PDBs to SENTRY_FOREIGN_PROJECT'
        booleanParam name: 'bDeploySentryBundleSources', defaultValue: true, description: 'Run sentry-cli difutil bundle-sources and upload source context with debug symbols. Enable only for projects allowed to upload source code.'
        string name: 'SENTRY_CREDENTIAL_ID', defaultValue: 'SENTRY_AUTH_INFO', description: 'Jenkins username/password credential: username=SENTRY_URL, password=SENTRY_AUTH_TOKEN'
        string name: 'SENTRY_ORG', defaultValue: 'kanohorizonia', description: 'Sentry organization slug for this project'
        string name: 'SENTRY_PROJECT', defaultValue: 'horizonuiplugindemo', description: 'Sentry project slug for this project'
        string name: 'SENTRY_FOREIGN_PROJECT', defaultValue: 'unrealengine', description: 'Separate Sentry project slug for foreign symbols such as Unreal Engine PDBs'
        string name: 'SENTRY_ENVIRONMENT', defaultValue: 'dev', description: 'Sentry deploy environment name'
    }

    stages {
        stage('UGS Build') {
            steps {
                script {
                    def configLoader = load '.jenkins/config.groovy'
                    def cfg = configLoader.projectConfig()
                    def config = unrealConfig(cfg + [
                        // Sentry
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
                }
            }
        }
    }
}
