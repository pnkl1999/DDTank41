using Game.Server;
using System;
using System.IO;
using System.Reflection;
using System.ServiceProcess;

namespace Game.Service
{
    public class GameServerService : ServiceBase
    {
        public GameServerService()
        {
			base.ServiceName = "ROAD";
			base.AutoLog = false;
			base.CanHandlePowerEvent = false;
			base.CanPauseAndContinue = false;
			base.CanShutdown = true;
			base.CanStop = true;
        }

        private static bool StartServer()
        {
			Directory.SetCurrentDirectory(new FileInfo(Assembly.GetExecutingAssembly().Location).DirectoryName);
			new FileInfo("./config/serverconfig.xml");
			GameServer.CreateInstance(new GameServerConfig());
			return GameServer.Instance.Start();
        }

        private static void StopServer()
        {
			GameServer.Instance.Stop();
        }

        protected override void OnStart(string[] args)
        {
			if (!StartServer())
			{
				throw new ApplicationException("Failed to start server!");
			}
        }

        protected override void OnStop()
        {
			StopServer();
        }

        protected override void OnShutdown()
        {
			StopServer();
        }

        public static ServiceController GetDOLService()
        {
			ServiceController[] services = ServiceController.GetServices();
			ServiceController[] array = services;
			foreach (ServiceController svcc in array)
			{
				if (svcc.ServiceName.ToLower().Equals("ROAD"))
				{
					return svcc;
				}
			}
			return null;
        }
    }
}
