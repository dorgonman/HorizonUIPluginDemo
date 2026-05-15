// .jenkins/Build/Test.Jenkinsfile
// Copyable test-focused consumer entrypoint.

@Library('kano-jenkins-unreal-pipeline-library') _

pipeline {
    agent none

    options {
        skipDefaultCheckout(true)
    }

    parameters {
        // === Standalone / Server Matrix ===
        booleanParam name: 'bBuildStandaloneWin64', defaultValue: true, description: 'Build Win64 standalone target'
        booleanParam name: 'bBuildServerWin64', defaultValue: false, description: 'Build Win64 server target'
        booleanParam name: 'bBuildStandaloneAndroid', defaultValue: false, description: 'Build Android standalone target'
        booleanParam name: 'bBuildServerAndroid', defaultValue: false, description: 'Build Android server target (unsupported)'
        booleanParam name: 'bBuildStandaloneIOS', defaultValue: false, description: 'Build iOS standalone target (requires Mac agent)'
        booleanParam name: 'bBuildServerIOS', defaultValue: false, description: 'Build iOS server target (unsupported)'
        booleanParam name: 'bBuildStandaloneMac', defaultValue: false, description: 'Build Mac standalone target (requires Mac agent)'
        booleanParam name: 'bBuildServerMac', defaultValue: false, description: 'Build Mac server target (requires Mac agent)'
        booleanParam name: 'bBuildStandaloneXSX', defaultValue: false, description: 'Build Xbox Series X standalone target'
        booleanParam name: 'bBuildServerXSX', defaultValue: false, description: 'Build Xbox Series X server target (unsupported)'
        booleanParam name: 'bBuildStandalonePS5', defaultValue: false, description: 'Build PlayStation 5 standalone target'
        booleanParam name: 'bBuildServerPS5', defaultValue: false, description: 'Build PlayStation 5 server target (unsupported)'
        booleanParam name: 'bBuildStandaloneSwitch2', defaultValue: false, description: 'Build Nintendo Switch 2 standalone target'
        booleanParam name: 'bBuildServerSwitch2', defaultValue: false, description: 'Build Nintendo Switch 2 server target (unsupported)'
        booleanParam name: 'bBuildStandaloneLinux', defaultValue: false, description: 'Build Linux standalone target'
        booleanParam name: 'bBuildServerLinux', defaultValue: false, description: 'Build Linux server target'

        // === Plugin Booleans ===
        booleanParam name: 'bValidatePlugins', defaultValue: false, description: 'Run plugin BuildPlugin validation. Plugin target toggles are ignored unless this is enabled.'
        booleanParam name: 'bBuildPluginWin64', defaultValue: false, description: 'Build Win64 Plugin Shipping'
        booleanParam name: 'bBuildPluginAndroid', defaultValue: false, description: 'Build Android Plugin Shipping'
        booleanParam name: 'bBuildPluginIOS', defaultValue: false, description: 'Build iOS Plugin Shipping'
        booleanParam name: 'bBuildPluginMac', defaultValue: false, description: 'Build Mac Plugin Shipping'
        booleanParam name: 'bBuildPluginXSX', defaultValue: false, description: 'Build Xbox Series X Plugin Shipping'
        booleanParam name: 'bBuildPluginPS5', defaultValue: false, description: 'Build PS5 Plugin Shipping'
        booleanParam name: 'bBuildPluginSwitch2', defaultValue: false, description: 'Build Switch 2 Plugin Shipping'
        booleanParam name: 'bBuildPluginLinux', defaultValue: false, description: 'Build Linux Plugin Shipping'

        // === Test ===
        booleanParam name: 'bRunTestWin64Standalone', defaultValue: true, description: 'Run Win64 standalone tests'
    }

    stages {
        stage('Build and Test') {
            steps {
                script {
                    unrealPipelineFromProjectConfig(
                        bootstrapAgentLabel: 'lightweight',
                        projectConfigPath: '.jenkins/config.groovy',
                        configOverrides: [
                            // Platform
                            bBuildStandaloneWin64: params.bBuildStandaloneWin64,
                            bBuildServerWin64: params.bBuildServerWin64,
                            bBuildStandaloneAndroid: params.bBuildStandaloneAndroid,
                            bBuildServerAndroid: params.bBuildServerAndroid,
                            bBuildStandaloneIOS: params.bBuildStandaloneIOS,
                            bBuildServerIOS: params.bBuildServerIOS,
                            bBuildStandaloneMac: params.bBuildStandaloneMac,
                            bBuildServerMac: params.bBuildServerMac,
                            bBuildStandaloneXSX: params.bBuildStandaloneXSX,
                            bBuildServerXSX: params.bBuildServerXSX,
                            bBuildStandalonePS5: params.bBuildStandalonePS5,
                            bBuildServerPS5: params.bBuildServerPS5,
                            bBuildStandaloneSwitch2: params.bBuildStandaloneSwitch2,
                            bBuildServerSwitch2: params.bBuildServerSwitch2,
                            bBuildStandaloneLinux: params.bBuildStandaloneLinux,
                            bBuildServerLinux: params.bBuildServerLinux,
                            // Plugin
                            bValidatePlugins: params.bValidatePlugins,
                            bBuildPluginWin64: params.bBuildPluginWin64,
                            bBuildPluginAndroid: params.bBuildPluginAndroid,
                            bBuildPluginIOS: params.bBuildPluginIOS,
                            bBuildPluginMac: params.bBuildPluginMac,
                            bBuildPluginXSX: params.bBuildPluginXSX,
                            bBuildPluginPS5: params.bBuildPluginPS5,
                            bBuildPluginSwitch2: params.bBuildPluginSwitch2,
                            bBuildPluginLinux: params.bBuildPluginLinux,
                            // Test
                            bRunTestWin64Standalone: params.bRunTestWin64Standalone,
                            // Config
                            buildConfiguration: 'Development',
                            workspaceSlot: 'Test',
                        ]
                    )
                }
            }
        }
    }
}
