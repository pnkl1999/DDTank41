using Bussiness.Managers;
using Fighting.Server;
using Fighting.Server.Games;
using Fighting.Server.Rooms;
using Game.Logic;
using log4net;
using System;
using System.Collections;
using System.Configuration;
using System.Reflection;

namespace Fighting.Service.action
{
    public class ConsoleStart : IAction
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);

        public string HelpStr=> ConfigurationSettings.AppSettings["HelpStr"];

        public string Name=> "--start";

        public string Syntax=> "--start [-config=./config/serverconfig.xml]";

        public string Description=> "Starts the Fighting server in console mode";

        public void OnAction(Hashtable parameters)
        {
			Console.Title = "Fighting Service | DDTank 3.0";
			FightServerConfig config = new FightServerConfig();
			try
			{
				config.Load();
			}
			catch (Exception ex2)
			{
				Console.WriteLine(ex2.Message);
				Console.ReadKey();
				return;
			}
			FightServer.CreateInstance(config);
			FightServer.Instance.Start();
			bool run = true;
			while (run)
			{
				try
				{
					Console.Write("> ");
					string[] para = Console.ReadLine().Split(' ');
					switch (para[0].ToLower())
					{
					case "clear":
						Console.Clear();
						break;
					case "list":
						if (para.Length > 1)
						{
							switch (para[1])
							{
							case "-client":
							{
								Console.WriteLine("server client list:");
								Console.WriteLine("--------------------");
								ServerClient[] allClients = FightServer.Instance.GetAllClients();
								for (int i = 0; i < allClients.Length; i++)
								{
									Console.WriteLine(allClients[i].ToString());
								}
								Console.WriteLine("-------------------");
								break;
							}
							case "-room":
							{
								Console.WriteLine("room list:");
								Console.WriteLine("-------------------------------");
								ProxyRoom[] allRoom = ProxyRoomMgr.GetAllRoom();
								for (int j = 0; j < allRoom.Length; j++)
								{
									Console.WriteLine(allRoom[j].ToString());
								}
								Console.WriteLine("-------------------------------");
								break;
							}
							case "-game":
								Console.WriteLine("game list:");
								Console.WriteLine("-------------------------------");
								foreach (BaseGame game in GameMgr.GetGames())
								{
									Console.WriteLine(game.ToString());
								}
								Console.WriteLine("-------------------------------");
								break;
							}
						}
						else
						{
							Console.WriteLine("list [-client][-room][-game]");
							Console.WriteLine("     -client:列出所有服务器对象");
							Console.WriteLine("     -room:列出所有房间对象");
							Console.WriteLine("     -game:列出所有游戏对象");
						}
						break;
					case "exit":
						run = false;
						break;
					case "cfg&reload":
						ConfigurationManager.RefreshSection("appSettings");
						Console.WriteLine("Configuration file is Reload!");
						break;
					case "drop&reload":
						if (DropMgr.ReLoad())
						{
							Console.WriteLine("Drop PvP Reload Sucess!");
						}
						else
						{
							Console.WriteLine("Error Reload Drop!");
						}
						break;
					}
				}
				catch (Exception ex)
				{
					Console.WriteLine("Error:" + ex.ToString());
				}
			}
			if (FightServer.Instance != null)
			{
				FightServer.Instance.Stop();
			}
        }
    }
}
