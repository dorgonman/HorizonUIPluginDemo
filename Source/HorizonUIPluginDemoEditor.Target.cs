// Created by dorgon, all right reserved.

using UnrealBuildTool;
using System.Collections.Generic;

public class HorizonUIPluginDemoEditorTarget : TargetRules
{
	public HorizonUIPluginDemoEditorTarget(TargetInfo Target)
	{
		Type = TargetType.Editor;
	}

	//
	// TargetRules interface.
	//

	public override void SetupBinaries(
		TargetInfo Target,
		ref List<UEBuildBinaryConfiguration> OutBuildBinaryConfigurations,
		ref List<string> OutExtraModuleNames
		)
	{
		OutExtraModuleNames.AddRange( new string[] { "HorizonUIPluginDemo" } );
	}
}
