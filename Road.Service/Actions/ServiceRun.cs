using System.Collections;
using System.ServiceProcess;

namespace Game.Service.actions
{
    public class ServiceRun : IAction
    {
        public string Name=> "--SERVICERUN";

        public string Syntax=> null;

        public string Description=> null;

        public void OnAction(Hashtable parameters)
        {
			ServiceBase.Run(new GameServerService());
        }
    }
}
