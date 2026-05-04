// .jenkins/Build/UGSBuild.Jenkinsfile
// Thin consumer entrypoint for shared UGSBuild orchestration.

@Library('jenkins-unreal-pipeline-library') _

pipeline {
    agent { label 'built-in' }

    options {
        skipDefaultCheckout(true)
    }

    parameters {
        // === Sentry Deploy Symbols ===
        booleanParam name: 'bDeploySentrySymbols', defaultValue: true, description: 'After standalone builds, create Sentry release/deploy records and upload debug symbols'
        string name: 'SENTRY_CREDENTIAL_ID', defaultValue: 'SENTRY_AUTH_INFO', description: 'Jenkins username/password credential: username=SENTRY_URL, password=SENTRY_AUTH_TOKEN'
        string name: 'SENTRY_ORG', defaultValue: 'kanohorizonia', description: 'Sentry organization slug for this project'
        string name: 'SENTRY_PROJECT', defaultValue: 'horizonuiplugindemo', description: 'Sentry project slug for this project'
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
                        sentryCredentialId: params.SENTRY_CREDENTIAL_ID?.trim() ?: cfg.sentryCredentialId,
                        sentryOrg: params.SENTRY_ORG?.trim() ?: cfg.sentryOrg,
                        sentryProject: params.SENTRY_PROJECT?.trim() ?: cfg.sentryProject,
                        sentryEnvironment: params.SENTRY_ENVIRONMENT?.trim() ?: cfg.sentryEnvironment,
                    ])
                    unrealUgsBuildPipeline(config: config)
                }
            }
        }
    }
}