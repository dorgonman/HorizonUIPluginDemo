using System;
using AutomationTool;
using Microsoft.Extensions.Logging;


namespace UnrealBuildBase
{
    class HorizonUIHelloWorld : BuildCommand
	{
		public override ExitCode Execute()
		{
			Logger.LogInformation("HorizonUI Hello World");

			return ExitCode.Success;
		}
	}
}
