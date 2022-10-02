using System;
using System.Collections;
using System.Configuration.Install;
using System.Reflection;
using System.Text;

namespace Game.Service.actions
{
    public class ServiceInstall : IAction
    {
        public string Name=> "--serviceinstall";

        public string Syntax=> "--serviceinstall";

        public string Description=> "Installs DOL as system service with he given parameters";

        public void OnAction(Hashtable parameters)
        {
			ArrayList temp = new ArrayList();
			temp.Add("/LogToConsole=false");
			StringBuilder tempString = new StringBuilder();
			foreach (DictionaryEntry entry in parameters)
			{
				if (tempString.Length > 0)
				{
					tempString.Append(" ");
				}
				tempString.Append(entry.Key);
				tempString.Append("=");
				tempString.Append(entry.Value);
			}
			temp.Add("commandline=" + tempString.ToString());
			string[] commandLine = (string[])temp.ToArray(typeof(string));
			AssemblyInstaller asmInstaller = new AssemblyInstaller(Assembly.GetExecutingAssembly(), commandLine);
			Hashtable rollback = new Hashtable();
			if (GameServerService.GetDOLService() != null)
			{
				Console.WriteLine("DOL service is already installed!");
				return;
			}
			Console.WriteLine("Installing Road as system service...");
			try
			{
				asmInstaller.Install(rollback);
				asmInstaller.Commit(rollback);
			}
			catch (Exception ex)
			{
				asmInstaller.Rollback(rollback);
				Console.WriteLine("Error installing as system service");
				Console.WriteLine(ex.Message);
				return;
			}
			Console.WriteLine("Finished!");
        }
    }
}
