using System;
using AutomationTool;


namespace AutomationTool
{
	class HorizonUIHelloWorld : BuildCommand
	{
		public override ExitCode Execute()
		{
			LogInformation("HorizonUI Hello World");

			return ExitCode.Success;
		}
	}
}
