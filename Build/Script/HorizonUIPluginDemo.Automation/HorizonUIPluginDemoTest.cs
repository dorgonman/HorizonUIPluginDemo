// Copyright 1998-2019 Epic Games, Inc. All Rights Reserved.

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Gauntlet;
using System.IO;
using System.IO.Compression;

namespace UE4Game
{

	public class HorizonUIPluginDemoTestConfig : UE4TestConfig
	{
		/// <summary>
		/// Map to use
		/// </summary>

		
		[AutoParam]
		public string AdditionalCommandLine = "";
		
		[AutoParam]
		public string ExecCmds = "automation SetMinimumPriority Critical;List;RunTests Plugin+Project.FunctionalTests;Quit";
        

        /// <summary>
        /// Applies these options to the provided app config
        /// </summary>
        /// <param name="AppConfig"></param>
        public override void ApplyToConfig(UnrealAppConfig AppConfig, UnrealSessionRole ConfigRole, IEnumerable<UnrealSessionRole> OtherRoles)
		{
			base.ApplyToConfig(AppConfig, ConfigRole, OtherRoles);

			AppConfig.CommandLine += "-ExecCmds=\"" + ExecCmds + "\"";
			AppConfig.CommandLine += AdditionalCommandLine;
			
	
		}
	}
	public class HorizonUIPluginDemoTest : UnrealTestNode<HorizonUIPluginDemoTestConfig>
	{
		public HorizonUIPluginDemoTest(UnrealTestContext InContext) : base(InContext)
		{
		}

		public override HorizonUIPluginDemoTestConfig GetConfiguration()
		{
			// just need a single client
			HorizonUIPluginDemoTestConfig Config = base.GetConfiguration();
			Config.MaxDuration = 5 * 600;		// 5min should be plenty
			int ClientCount = Context.TestParams.ParseValue("numclients", 1);
			bool WithServer = Context.TestParams.ParseParam("server");

			if (ClientCount > 0)
			{
				Config.RequireRoles(UnrealTargetRole.Client, ClientCount);
			}

			if (WithServer)
			{
				Config.RequireRoles(UnrealTargetRole.Server, 1);
			}

			UnrealTestRole ClientRole = Config.RequireRole(UnrealTargetRole.Client);

			ClientRole.Controllers.Add("HorizonUI");
			return Config;
		}
		public override void CreateReport(TestResult Result, UnrealTestContext Contex, UnrealBuildSource Build, IEnumerable<UnrealRoleArtifacts> Artifacts, string ArtifactPath)
		{
			//UnrealRoleArtifacts ClientArtifacts = Artifacts.Where(A => A.SessionRole.RoleType == UnrealTargetRole.Client).FirstOrDefault();

			//var SnapshotSummary = new UnrealSnapshotSummary<UnrealHealthSnapshot>(ClientArtifacts.AppInstance.StdOut);

			//Log.Info("HorizonUIPluginDemoTest Performance Report");
			//Log.Info(SnapshotSummary.ToString());

			base.CreateReport(Result, Contex, Build, Artifacts, ArtifactPath);
		}

		public override void SaveArtifacts_DEPRECATED(string OutputPath)
		{
			//string UploadFolder = Globals.Params.ParseValue("uploadfolder", "");
			//if (UploadFolder.Count() > 0 && Directory.CreateDirectory(UploadFolder).Exists)
			//{
			//	string PlatformString = TestInstance.ClientApps[0].Device.Platform.ToString();
			//	string ArtifactDir = TestInstance.ClientApps[0].ArtifactPath;
			//	string ProfilingDir = Path.Combine(ArtifactDir, "Profiling");
			//	string FPSChartsDir = Path.Combine(ProfilingDir, "FPSChartStats").ToLower();
			//	string FpsChartsZipPath = Path.Combine(TestInstance.ClientApps[0].ArtifactPath, "FPSCharts.zip").ToLower();
			//	if (Directory.Exists(FPSChartsDir))
			//	{
			//		ZipFile.CreateFromDirectory(FPSChartsDir, FpsChartsZipPath);
   //                 string DestFileName = "HorizonUIPluginDemoTest-" + PlatformString + ".zip";
   //                 string DestZipFile = Path.Combine(UploadFolder, DestFileName);
			//		File.Copy(FpsChartsZipPath, DestZipFile);
			//	}
			//}
			//else
			//{
			//	Log.Info("Not uploading CSV Result UploadFolder: '" + UploadFolder + "'");
			//}
		}
	}
// 	/// <summary>
// 	/// Runs automated tests on a platform
// 	/// </summary>
// 	public class HorizonUIPluginDemoDefaultTest : DefaultTest
// 	{
//         [AutoParam("")]
//         protected string ReportOutputPath { get; set; }
//         public HorizonUIPluginDemoDefaultTest(Gauntlet.UnrealTestContext InContext)
// 			: base(InContext)
// 		{
// 		}

// 		public override UE4TestConfig GetConfiguration()
// 		{
// 			// just need a single client
// 			UE4TestConfig Config = base.GetConfiguration();

//             UnrealTestRole ClientRole = Config.RequireRole(UnrealTargetRole.Client);
//             ClientRole.CommandLine += string.Format(" " +
//                 "-ExecCmds=\"automation " +
//                 "RunTests HorizonUI.SuccessTest;" +
//                 //"RunTests Project.Maps;" +
//                 "Quit\" " +
//                 "-nullrhi -unattended -nopause -ReportOutputPath={0}", ReportOutputPath);
//             // IMPLEMENT_COMPLEX_AUTOMATION_TEST(FLoadAllMapsInGameTest, "Project.Maps.Load All In Game", EAutomationTestFlags::ClientContext | EAutomationTestFlags::StressFilter)
//             ClientRole.Controllers.Add("HorizonUI");


// 			return Config;
// 		}


// 	}
}
