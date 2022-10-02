using Game.Base.Packets;
using Game.Server.LittleGame.Objects;
using Game.Server.Packets;

namespace Game.Server.LittleGame.Handle
{
    [LittleGame(65)]
	internal class Click : ILittleGameCommandHandler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			int key = packet.ReadInt();
			int num = packet.ReadInt();
			int num2 = packet.ReadInt();
			int num3 = packet.ReadInt();
			int num4 = packet.ReadInt();
			if (LittleGameWorldMgr.ScenariObjects.ContainsKey(key))
			{
				Bogu bogu = LittleGameWorldMgr.ScenariObjects[key] as Bogu;
				if (bogu == null)
				{
					//Player.Out.SendMessage(eMessageType.ChatERROR, "哎呀呀呀......它竟然被你抓住了.");
					return 0;
				}
				lock (bogu.Locker)
				{
					if (bogu.Сaught && bogu.Catchers.Count >= bogu.MaxCatchers)
					{
						return 0;
					}
					if (num > num3 && num2 >= num4)
					{
						Player.LittleGameInfo.Direction = "rightDown";
						Player.LittleGameInfo.IsBack = false;
						bogu.Direction = "rightDown";
						bogu.IsBack = false;
					}
					else if (num > num3 && num2 < num4)
					{
						Player.LittleGameInfo.Direction = "rightUp";
						Player.LittleGameInfo.IsBack = true;
						bogu.Direction = "rightUp";
						bogu.IsBack = true;
					}
					else if (num < num3 && num2 >= num4)
					{
						Player.LittleGameInfo.Direction = "leftDown";
						Player.LittleGameInfo.IsBack = false;
						bogu.Direction = "leftDown";
						bogu.IsBack = false;
					}
					else if (num < num3 && num2 < num4)
					{
						Player.LittleGameInfo.Direction = "leftUp";
						Player.LittleGameInfo.IsBack = true;
						bogu.Direction = "leftUp";
						bogu.IsBack = true;
					}
					bogu.X = num;
					bogu.Y = num2;
					bogu.Сaught = true;
					bogu.Catchers.Add(Player);
					Player.LittleGameInfo.Bogu = bogu;
					Player.LittleGameInfo.Actions.Enqueue("livingInhale");
					if (bogu.Size < 2)
					{
						LittleGameWorldMgr.Out.SendAddObject(Player, bogu, "normalbogu");
					}
					else if (bogu.Catchers.Count < bogu.MaxCatchers)
					{
						LittleGameWorldMgr.Out.SendAddObject(Player, bogu, "bogugiveup");
					}
					else
					{
						foreach (GamePlayer catcher in bogu.Catchers)
						{
							LittleGameWorldMgr.Out.SendAddObject(catcher, bogu, "bigbogu");
						}
					}
				}
				return 0;
			}
			//Player.Out.SendMessage(eMessageType.ChatERROR, "哎呀呀呀......它竟然溜走了.");
			return 0;
        }
    }
}
