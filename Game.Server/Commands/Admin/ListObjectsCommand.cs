using Game.Base;
using Game.Logic;
using Game.Server.Battle;
using Game.Server.Games;
using Game.Server.Managers;
using Game.Server.Rooms;
using System;
using System.Collections.Generic;

namespace Game.Server.Commands.Admin
{
    [Cmd("&list", ePrivLevel.Player, "List the objects info in game", new string[]
	{
		"   /list [Option1][Option2] ...",
		"eg:    /list -g :list all game objects",
		"       /list -c :list all client objects",
		"       /list -p :list all gameplaye objects",
		"       /list -r :list all room objects",
		"       /list -b :list all battle servers"
	})]
	public class ListObjectsCommand : AbstractCommandHandler, ICommandHandler
    {
        public bool OnCommand(BaseClient client, string[] args)
        {
			if (args.Length > 1)
			{
				//switch (args[1])
				//{
				//case "-c":
				//{
				//	Console.WriteLine("client list:");
				//	Console.WriteLine("-------------------------------");
				//	GameClient[] allClients = GameServer.Instance.GetAllClients();
				//	GameClient[] array = allClients;
				//	for (int i = 0; i < array.Length; i++)
				//	{
				//		Console.WriteLine(array[i].ToString());
				//	}
				//	Console.WriteLine("-------------------------------");
				//	Console.WriteLine($"total:{allClients.Length}");
				//	return true;
				//}
				//case "-p":
				//{
				//	Console.WriteLine("player list:");
				//	Console.WriteLine("-------------------------------");
				//	GamePlayer[] allPlayers = WorldMgr.GetAllPlayers();
				//	GamePlayer[] array2 = allPlayers;
				//	for (int j = 0; j < array2.Length; j++)
				//	{
				//		Console.WriteLine(array2[j].ToString());
				//	}
				//	Console.WriteLine("-------------------------------");
				//	Console.WriteLine($"total:{allPlayers.Length}");
				//	return true;
				//}
				//case "-r":
				//{
				//	Console.WriteLine("room list:");
				//	Console.WriteLine("-------------------------------");
				//	List<BaseRoom> allUsingRoom = RoomMgr.GetAllUsingRoom();
				//	foreach (BaseRoom item in allUsingRoom)
				//	{
				//		Console.WriteLine(item.ToString());
				//	}
				//	Console.WriteLine("-------------------------------");
				//	Console.WriteLine($"total:{allUsingRoom.Count}");
				//	return true;
				//}
				//case "-g":
				//{
				//	Console.WriteLine("game list:");
				//	Console.WriteLine("-------------------------------");
				//	List<BaseGame> allGame = GameMgr.GetAllGame();
				//	foreach (BaseGame item2 in allGame)
				//	{
				//		Console.WriteLine(item2.ToString());
				//	}
				//	Console.WriteLine("-------------------------------");
				//	Console.WriteLine($"total:{allGame.Count}");
				//	return true;
				//}
				//case "-b":
				//{
				//	Console.WriteLine("battle list:");
				//	Console.WriteLine("-------------------------------");
				//	List<BattleServer> allBattles = BattleMgr.GetAllBattles();
				//	foreach (BattleServer item3 in allBattles)
				//	{
				//		Console.WriteLine(item3.ToString());
				//	}
				//	Console.WriteLine("-------------------------------");
				//	Console.WriteLine($"total:{allBattles.Count}");
				//	return true;
				//}
				//}
				//DisplaySyntax(client);
			}
			else
			{
				//DisplaySyntax(client);
			}
			return true;
        }
    }
}
