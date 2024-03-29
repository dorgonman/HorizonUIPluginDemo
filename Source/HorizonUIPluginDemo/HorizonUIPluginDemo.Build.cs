// Created by dorgon, all right reserved.
using System;
using System.IO;
using UnrealBuildTool;
public class HorizonUIPluginDemo : ModuleRules
{
	public HorizonUIPluginDemo(ReadOnlyTargetRules Target)
        : base(Target)
    {
        PCHUsage = PCHUsageMode.UseExplicitOrSharedPCHs;
        PublicDependencyModuleNames.AddRange(new string[] { "Core", "CoreUObject", "Engine", "InputCore" });
		PublicDependencyModuleNames.AddRange(new string[] { "UMG", "Paper2D", "SlateCore", "Slate", "HorizonUI" });
        PrivateDependencyModuleNames.AddRange(new string[] { "Gauntlet"});

		PrivateDependencyModuleNames.AddRange(new string[] {   });


		string ProjectPath = Path.GetFullPath(Path.Combine(ModuleDirectory, "../../"));
		if(Target.ProjectFile != null)
		{
			ProjectPath = Path.GetDirectoryName(Target.ProjectFile.ToString());

		}
        // https://docs.unrealengine.com/en-US/Platforms/Mobile/UnrealPluginLanguage/index.html
        AdditionalPropertiesForReceipt.Add("AndroidPlugin", Path.Combine(ProjectPath, "Source", "Game_UPL.xml"));

		// Uncomment if you are using Slate UI
		// PrivateDependencyModuleNames.AddRange(new string[] { "Slate", "SlateCore" });
		
		// Uncomment if you are using online features
		// PrivateDependencyModuleNames.Add("OnlineSubsystem");
		// if ((Target.Platform == UnrealTargetPlatform.Win32) || (Target.Platform == UnrealTargetPlatform.Win64))
		// {
		//		if (UEBuildConfiguration.bCompileSteamOSS == true)
		//		{
		//			DynamicallyLoadedModuleNames.Add("OnlineSubsystemSteam");
		//		}
		// }
	}
}
