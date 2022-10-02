using System;
using System.Collections;
using System.Configuration.Install;
using System.Reflection;

namespace Game.Service.actions
{
    public class ServiceUninstall : IAction
    {
        public string Name=> "--serviceuninstall";

        public string Syntax=> "--serviceuninstall";

        public string Description=> "Uninstalls the DOL system service";

        public void OnAction(Hashtable parameters)
        {
			AssemblyInstaller asmInstaller = new AssemblyInstaller(Assembly.GetExecutingAssembly(), new string[1]
			{
				"/LogToConsole=false"
			});
			Hashtable rollback = new Hashtable();
			if (GameServerService.GetDOLService() == null)
			{
				Console.WriteLine("No service named \"DOL\" found!");
				return;
			}
			Console.WriteLine("Uninstalling DOL system service...");
			try
			{
				asmInstaller.Uninstall(rollback);
			}
			catch (Exception ex)
			{
				Console.WriteLine("Error uninstalling system service");
				Console.WriteLine(ex.Message);
				return;
			}
			Console.WriteLine("Finished!");
        }
    }
}
