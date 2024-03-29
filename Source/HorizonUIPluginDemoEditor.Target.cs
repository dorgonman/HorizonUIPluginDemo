// Created by dorgon, all right reserved.

using UnrealBuildTool;
using System.Collections.Generic;

public class HorizonUIPluginDemoEditorTarget : TargetRules
{
	public HorizonUIPluginDemoEditorTarget(TargetInfo Target) : base(Target)
    {
		Type = TargetType.Editor;
        ExtraModuleNames.AddRange(new string[] { "HorizonUIPluginDemo" });
        DefaultBuildSettings = BuildSettingsVersion.Latest;
        IncludeOrderVersion = EngineIncludeOrderVersion.Latest;
        // StrictIncludes for Plugin Demo Build to check if all source files have self-contained headers
        // -NoPCH -NoSharedPCH -DisableUnity
        // {
        //     bUsePCHFiles = false;
        //     bUseSharedPCHs = false;
        //     bUseUnityBuild = false;
        // }
    }

}
