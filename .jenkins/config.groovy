// HorizonUIPluginDemo — Jenkins Shared Library consumer configuration
// This file is thin: project-specific values only. All orchestration lives in the shared library.

def projectConfig() {
    return [
        // === Required (unrealConfig will fail-fast if missing) ===
        projectRoot:        '.',
        sharedLibraryName:   'jenkins-unreal-pipeline-library',

        // === Agent Selection ===
        windowsAgentLabel:   'unreal-win64',  // Consumer: set to match your Jenkins Windows agent pool
        macAgentLabel:       'unreal-mac',
        linuxAgentLabel:     'unreal-linux',

        // === Producer/aggregate routing labels (optional overrides) ===
        // Use these to route specific producer types to separate agent pools.
        // If unset, fall back to the base labels above.
        // Standalone producers:
        win64StandaloneAgentLabel: '',   // override for Win64 standalone builds; '' = use windowsAgentLabel
        macStandaloneAgentLabel:   '',   // override for Mac standalone builds; '' = use macAgentLabel
        linuxStandaloneAgentLabel: '',   // override for Linux standalone builds; '' = use linuxAgentLabel
        // UGS producers:
        win64UgsAgentLabel:       '',   // override for Win64 UGS producer; '' = use windowsAgentLabel
        macUgsAgentLabel:         '',   // override for Mac UGS producer; '' = use macAgentLabel
        linuxUgsAgentLabel:       '',   // override for Linux UGS producer; '' = use linuxAgentLabel

        // === Consumer metadata ===
        scriptRoot:         'Build',
        reportRoot:         'Intermediate/BuildPackage',
        slug:               'HorizonUIPluginDemo',
        workspaceSlot:      'Package',
        win64SharedWorkspaceRoot: 'C:/_agent/_jenkins/agent/workspace/HorizonPlugin',
        macSharedWorkspaceRoot: '/Users/Shared/jenkins/agent/workspace/HorizonPlugin',
        linuxSharedWorkspaceRoot: '/var/jenkins/home/ws/HorizonPlugin',

        // === Build Intermediate Paths ===
        // Resolved relative to projectRoot at runtime; exported as env vars by unrealPipeline
        buildArchiveArtifactRoot: 'Intermediate/BuildArchive',
        buildPackageArtifactRoot: 'Intermediate/BuildPackage',
        buildPluginArtifactRoot: 'Intermediate/BuildPlugin',
        buildUgsArtifactRoot:    'Intermediate/BuildUGS',

        // === build toggles ===
        bCleanSCM:          false,
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
        bRunAggregatePhase:     false,  // Set to true to enable Job D aggregate stage
        bRunPrepareDeployPhase: false,
        bRunDeployPhase:        false,
        bPrepareNuGetPackage:   false,
        bDeployNuGetPackage:    false,
        bDeployPerforce:        false,
        nugetFeed:              'https://api.nuget.org/v3/index.json',

        // === Aggregate stage (Job D) ===
        // Workspace for aggregation: any agent with nuget/buildgraph capability
        aggregateAgentLabel:    'unreal-win64',  // Can be any: 'any', 'unreal-win64', etc.
        deployWorkspace:        '',  // Auto-resolved if empty: "${sharedWorkspaceRoot}/HorizonPlugin/HorizonUIPluginDemo/Deploy"
        bRunBuildGraphAggregation: false,

        // === Test + Coverage ===
        bRunTestStandaloneWin64: true,
        coverageFormat:     ['xml', 'html'],
        buildConfiguration: 'Development',
        bDeploySentrySymbols: true,
        bCopyPreCompileEngine: false,
        preArchiveCopyStep: '',
        sentryCredentialId: 'SENTRY_AUTH_INFO',
        sentryOrg: '',
sentryProject: '',
        sentryForeignProject: 'unrealengine',
        sentryEnvironment: 'dev',
        bUploadToUnrealHordeServer: false,
        bDeployUnrealHordeServer: false,
        unrealHordeServer:  'http://unrealhorde.local/',
        hordeToken:        '',  // Set via HORDE_TOKEN Jenkins parameter; empty here
        hordeGitStreamRepo: 'https://dev.azure.com/kanohorizonia/UEHorizonPlugin/_git/HorizonUIPluginDemo',  // Repo URL for Horde stream ID (without trailing .git)

        // === Plugin-specific ===
        pluginName:         'HorizonUIPlugin',

        // === Consumer metadata ===
        projectName:        'HorizonUIPluginDemo',
        uprojectPath:       'HorizonUIPluginDemo.uproject',
    ]
}

return this
