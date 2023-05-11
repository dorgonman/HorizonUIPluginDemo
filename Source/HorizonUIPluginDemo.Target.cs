// Created by dorgon, all right reserved.

using UnrealBuildTool;
using System.Collections.Generic;

public class HorizonUIPluginDemoTarget : TargetRules
{
	public HorizonUIPluginDemoTarget(TargetInfo Target) : base(Target)
    {
		Type = TargetType.Game;
        ExtraModuleNames.AddRange(new string[] { "HorizonUIPluginDemo" });
        DefaultBuildSettings = BuildSettingsVersion.V2;
        // ShadowVariableWarningLevel = WarningLevel.Error;
        IncludeOrderVersion = EngineIncludeOrderVersion.Latest;
    }

}
