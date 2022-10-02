using System;
using System.Collections;
using System.ServiceProcess;

namespace Game.Service.actions
{
    public class ServiceStop : IAction
    {
        public string Name=> "--servicestop";

        public string Syntax=> "--servicestop";

        public string Description=> "Stops the DOL system service";

        public void OnAction(Hashtable parameters)
        {
			ServiceController svcc = GameServerService.GetDOLService();
			if (svcc == null)
			{
				Console.WriteLine("You have to install the service first!");
				return;
			}
			if (svcc.Status == ServiceControllerStatus.StartPending)
			{
				Console.WriteLine("Server is still starting, please check the logfile for progress information!");
				return;
			}
			if (svcc.Status != ServiceControllerStatus.Running)
			{
				Console.WriteLine("The DOL service is not running");
				return;
			}
			try
			{
				Console.WriteLine("Stopping the DOL service...");
				svcc.Stop();
				svcc.WaitForStatus(ServiceControllerStatus.Stopped);
				Console.WriteLine("Finished!");
			}
			catch (InvalidOperationException ex)
			{
				Console.WriteLine("Could not stop the DOL service!");
				Console.WriteLine(ex.Message);
			}
        }
    }
}
