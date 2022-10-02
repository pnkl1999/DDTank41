using System.Collections;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Configuration.Install;
using System.ServiceProcess;

namespace Game.Service
{
    [RunInstaller(true)]
	public class GameServerServiceInstaller : Installer
    {
        private ServiceInstaller m_gameServerServiceInstaller;

        private ServiceProcessInstaller m_gameServerServiceProcessInstaller;

        public GameServerServiceInstaller()
        {
			m_gameServerServiceProcessInstaller = new ServiceProcessInstaller();
			m_gameServerServiceProcessInstaller.Account = ServiceAccount.LocalSystem;
			m_gameServerServiceInstaller = new ServiceInstaller();
			m_gameServerServiceInstaller.StartType = ServiceStartMode.Manual;
			m_gameServerServiceInstaller.ServiceName = "ROAD";
			base.Installers.Add(m_gameServerServiceProcessInstaller);
			base.Installers.Add(m_gameServerServiceInstaller);
        }

        public override void Install(IDictionary stateSaver)
        {
			StringDictionary parameters = base.Context.Parameters;
			parameters["assemblyPath"] = parameters["assemblyPath"] + " --SERVICERUN " + base.Context.Parameters["commandline"];
			base.Install(stateSaver);
        }
    }
}
