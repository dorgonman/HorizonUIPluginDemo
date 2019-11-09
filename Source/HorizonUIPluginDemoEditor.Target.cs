// Created by dorgon, all right reserved.

using UnrealBuildTool;
using System.Collections.Generic;

public class HorizonUIPluginDemoEditorTarget : TargetRules
{
	public HorizonUIPluginDemoEditorTarget(TargetInfo Target) : base(Target)
    {
		Type = TargetType.Editor;
        ExtraModuleNames.AddRange(new string[] { "HorizonUIPluginDemo" });
        DefaultBuildSettings = BuildSettingsVersion.V2;
        bUsePCHFiles = false;
        bUseSharedPCHs = false;
        bUseUnityBuild = false;
    }

}
