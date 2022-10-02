using Bussiness.Protocol;
using Center.Server;
using Game.Base;
using Game.Service;
using log4net;
using System;
using System.Collections;
using System.Configuration;
using System.Reflection;

namespace Center.Service.actions
{
    public class ConsoleStart : IAction
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public string HelpStr=> ConfigurationSettings.AppSettings["HelpStr"];

        public string Name=> "--start";

        public string Syntax=> "--start [-config=./config/serverconfig.xml]";

        public string Description=> "Starts the DOL server in console mode";

        private static bool StartServer()
        {
			Console.Title = "Center Service | DDTank 3.0";
			return CenterServer.Instance.Start();
        }

        public void OnAction(Hashtable parameters)
        {
			CenterServer.CreateInstance(new CenterServerConfig());
			StartServer();
			ConsoleClient client = new ConsoleClient();
			bool run = true;
			while (run)
			{
				try
				{
					Console.Write("> ");
					string line = Console.ReadLine();
					string[] para = line.Split('&');
					switch (para[0].ToLower())
					{
					case "exit":
						run = false;
						continue;
					case "notice":
						if (para.Length < 2)
						{
							Console.WriteLine("You need enter a valid parameter!");
						}
						else
						{
							CenterServer.Instance.SendSystemNotice(para[1]);
						}
						continue;
					case "reload":
						if (para.Length < 2)
						{
							Console.WriteLine("You need enter a valid parameter!");
						}
						else
						{
							CenterServer.Instance.SendReload(para[1]);
						}
						continue;
					case "shutdown":
						CenterServer.Instance.SendShutdown();
						continue;
					case "help":
						Console.WriteLine(HelpStr);
						continue;
					case "AAS":
						if (para.Length < 2)
						{
							Console.WriteLine("You need enter TRUE or FALSE in parameter!");
						}
						else
						{
							CenterServer.Instance.SendAAS(bool.Parse(para[1]));
						}
						continue;
					}
					if (line.Length <= 0)
					{
						continue;
					}
					if (line[0] == '/')
					{
						line = line.Remove(0, 1);
						line = line.Insert(0, "&");
					}
					try
					{
						if (!CommandMgr.HandleCommandNoPlvl(client, line))
						{
							Console.WriteLine("Unknown command: " + line);
						}
					}
					catch (Exception e)
					{
						Console.WriteLine(e.ToString());
					}
				}
				catch (Exception ex)
				{
					Console.WriteLine("Error:" + ex.ToString());
				}
			}
			if (CenterServer.Instance != null)
			{
				CenterServer.Instance.Stop();
			}
        }

        public void Reload(eReloadType type)
        {
        }
    }
}
