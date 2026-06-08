// HorizonUIPluginDemo — Jenkins Shared Library consumer configuration
// This file is thin: project-specific values only. All orchestration lives in the shared library.

def projectConfig() {
    return [
        // === Required (unrealConfig will fail-fast if missing) ===
        projectRoot:        '.',
        sharedLibraryName:   'kano-jenkins-unreal-pipeline-library',

        // === Agent Selection ===
        windowsAgentLabel:   'windows && unreal',
        macAgentLabel:       'mac && unreal',
        linuxAgentLabel:     'linux && unreal',
        unrealEngineRoot:    'H:/EpicGames/Installed/UE_5.7',

        // === Producer/aggregate routing labels (optional overrides) ===
        // Use these to route specific producer types to separate agent pools.
        // If unset, fall back to the base labels above.
        // Standalone producers:
        win64StandaloneAgentLabel: '',   // override for Win64 standalone builds; '' = use windowsAgentLabel
        macStandaloneAgentLabel:   '',   // override for Mac standalone builds; '' = use macAgentLabel
        linuxStandaloneAgentLabel: '',   // override for Linux standalone builds; '' = use linuxAgentLabel
        // UGS producers:
        win64UgsAgentLabel:       'windows && unreal && ugs',
        macUgsAgentLabel:         'mac && unreal',
        linuxUgsAgentLabel:       'linux && unreal',

        // === Consumer metadata ===
        scriptRoot:         'Build',
        reportRoot:         'Intermediate/BuildArtifacts/BuildPackage',
        kanoReportRendererMode: 'auto',
        slug:               'HorizonUIPluginDemo',
        scmCredentialId:    'dorgonman_azuredevops',
        macLoginKeychainCredentialId: 'MAC_LOGIN_USER',
        workspaceSlot:      'Package',
        win64SharedWorkspaceRoot: 'C:/Mount/s/jenkins_ws/HorizonPlugin',
        macSharedWorkspaceRoot: '/Users/Shared/agent/jenkins_ws/HorizonPlugin',
        linuxSharedWorkspaceRoot: '/var/jenkins/home/_ws/HorizonPlugin',

        // === Build Intermediate Paths ===
        // Resolved relative to projectRoot at runtime; exported as env vars by unrealPipeline
        buildArchiveArtifactRoot: 'Intermediate/BuildArchive',
        buildPackageArtifactRoot: 'Intermediate/BuildPackage',
        buildPluginArtifactRoot: 'Intermediate/BuildPlugin',
        buildUgsArtifactRoot:    'Intermediate/BuildUGS',

        // === build toggles ===
        bCleanBuild:        false,
        bBuildStandaloneWin64: true,
        bBuildServerWin64:  false,
        bBuildPluginWin64:  true,
        bBuildStandaloneAndroid: false,
        bBuildServerAndroid: false,
        bBuildStandaloneMac: false,
        bBuildServerMac:    false,
        bBuildStandaloneLinux: false,
        bBuildServerLinux:  false,
        bBuildStandaloneIOS: false,
        bBuildServerIOS:    false,
        bBuildStandaloneXSX: false,
        bBuildServerXSX:    false,
        bBuildStandalonePS5: false,
        bBuildServerPS5:    false,
        bBuildStandaloneSwitch2: false,
        bBuildServerSwitch2: false,

        // === UGS phase toggles ===
        bRunBuildPhase:         true,
        bBuildUGSStageWin64:    true,
        bBuildUGSStageMac:      true,
        bBuildUGSStageLinux:    false,
        bRunAggregatePhase:     false,  // Set to true to enable Job D aggregate stage
        bRunPrepareDeployPhase: false,
        bRunDeployPhase:        false,
        bPrepareNuGetPackage:   false,
        bDeployNuGetPackage:    false,
        bDeployPerforce:        false,
        nugetFeed:              'https://api.nuget.org/v3/index.json',

        // === Aggregate stage (Job D) ===
        // Workspace for UGS aggregation / NuGet / deploy. Use deploy-capable labels, not physical node names.
        // UGS producers stash only ArchiveForUGS/Staging/** from buildUgsArtifactRoot, then the
        // deploy workspace unstashes Win64/Mac/Linux into buildUgsArtifactRoot/ArchiveForUGS/Staging.
        ugsDeployAgentLabel:    'windows && unreal && deploy',
        macDeployAgentLabel:    'mac && unreal && deploy',
        iosAgentLabel:          'mac && unreal',
        gpuTestAgentLabel:      'windows && unreal && gpu',

        // AutoSDK target builds. Linux target is cross-compiled through Windows AutoSDK;
        // linuxAgentLabel remains reserved for Linux host agents.
        autoSdkAgentLabel:      'windows && unreal && autosdk',
        androidAgentLabel:      'windows && unreal && autosdk',
        linuxTargetAgentLabel:  'windows && unreal && autosdk',
        linuxTargetHostPlatform: 'Win64',
        ps5AgentLabel:          'windows && unreal && autosdk',
        xsxAgentLabel:          'windows && unreal && autosdk',
        switch2AgentLabel:      'windows && unreal && autosdk',

        // UGS aggregate/NuGet/Horde stages share one Deploy workspace.
        // Workspace is derived by shared library from platform shared roots:
        //   <platformSharedWorkspaceRoot>/<projectName>/Deploy
        // Effective UGS staging path:
        //   <derivedDeployWorkspace>/buildUgsArtifactRoot/ArchiveForUGS/Staging
        bRunBuildGraphAggregation: false,

        // === Deploy boundary policy ===
        // UGSBuild may prepare NuGet packages and upload to Horde when its job parameter enables it.
        // NuGet push and Perforce publish stay disabled by default; modern Deploy Targets stay dry-run only.
        bRunDeployTargets: false,
        bDeployTargetsDryRunOnly: true,
        bAllowRealDeployTargets: false,

        // === Test + Coverage ===
        bRunTestWin64Standalone: true,
        coverageFormat:     ['xml', 'html'],
        buildConfiguration: 'Development',
        bDeploySentrySymbols: true,
        bDeploySentryForeignUnrealEngineSymbols: false,
        bCopyPreCompileEngine: true,
        preArchiveCopyStep: 'Default',
        sentryCredentialId: 'SENTRY_AUTH_INFO',
        sentryOrg: 'kanohorizonia',
        sentryProject: 'horizonuiplugindemo',
        sentryForeignProject: 'unrealengine',
        sentryEnvironment: 'dev',
        bDeployUnrealHordeServer: false,
        unrealHordeServer:  'http://unrealhorde.local/',
        hordeToken:        '',  // Set via HORDE_TOKEN Jenkins parameter; empty here
        hordeGitStreamRepo: 'https://dev.azure.com/kanohorizonia/UEHorizonPlugin/_git/HorizonUIPluginDemo',  // Repo URL for Horde stream ID (without trailing .git)
        ugsProjectKey: '//UEHorizonPlugin/HorizonUIPluginDemo/main/HorizonUIPluginDemo.uproject',

        // === Plugin Validation ===
        // Plugin validation is opt-in in the shared library. This PluginDemo project enables it explicitly.
        bValidatePlugins:   true,
        pluginName:         'HorizonUIPlugin',
        pluginValidationPaths: [
            'Plugins/HorizonUIPlugin/HorizonUIPlugin.uplugin',
        ],
        pluginValidationIncludeRegex: '^Plugins/.*\\.uplugin$',
        pluginValidationExcludeRegex: '^Plugins/Marketplace/',

        // === Consumer metadata ===
        projectName:        'HorizonUIPluginDemo',
        uprojectPath:       'HorizonUIPluginDemo.uproject',
    ]
}

return this
