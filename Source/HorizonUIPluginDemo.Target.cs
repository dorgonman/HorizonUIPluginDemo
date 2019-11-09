// Created by dorgon, all right reserved.

using UnrealBuildTool;
using System.Collections.Generic;
using Tools.DotNETCommon;

public class HorizonUIPluginDemoTarget : TargetRules
{
	public HorizonUIPluginDemoTarget(TargetInfo Target) : base(Target)
    {
		Type = TargetType.Game;
        ExtraModuleNames.AddRange(new string[] { "HorizonUIPluginDemo" });
        //ResourceCompileEnvironment.Definitions.Add(String.Format("BUILD_VERSION={0}", Target.BuildVersion));
        //Log.TraceInformation("==========BuildVersion '{0}'", BuildVersion);
    }

}
