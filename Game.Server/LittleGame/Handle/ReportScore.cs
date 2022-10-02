using Game.Base.Packets;
using Game.Server.LittleGame.Objects;
using Game.Server.Packets;

namespace Game.Server.LittleGame.Handle
{
    [LittleGame(64)]
	internal class ReportScore : ILittleGameCommandHandler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			int value = packet.ReadInt();
			int key = packet.ReadInt();
			if (LittleGameWorldMgr.ScenariObjects.ContainsKey(key))
			{
				Bogu bogu = LittleGameWorldMgr.ScenariObjects[key] as Bogu;
				if (bogu == null)
				{
					if (Player.LittleGameInfo.Actions.Peek() == "livingInhale")
					{
						Player.LittleGameInfo.Actions.Clear();
					}
					Player.LittleGameInfo.Actions.Enqueue("livingUnInhale");
					//Player.Out.SendMessage(eMessageType.ChatERROR, "哎呀呀呀......它竟然被你抓住了.");
					return 0;
				}
				lock (bogu.Locker)
				{
					bogu.Catchers.Remove(Player);
					if (bogu.Catchers.Count == 0)
					{
						bogu.Action = "livingDie";
						LittleGameWorldMgr.RemoveBogu(bogu);
					}
					Player.LittleGameInfo.Bogu = null;
					Player.AddScore(value);
					if (Player.LittleGameInfo.Actions.Peek() == "livingInhale")
					{
						Player.LittleGameInfo.Actions.Clear();
					}
					Player.LittleGameInfo.Actions.Enqueue("livingUnInhale");
				}
				return 0;
			}
			if (Player.LittleGameInfo.Actions.Peek() == "livingInhale")
			{
				Player.LittleGameInfo.Actions.Clear();
			}
			Player.LittleGameInfo.Actions.Enqueue("livingUnInhale");
			//Player.Out.SendMessage(eMessageType.ChatERROR, "哎呀呀呀......它竟然溜走了.");
			return 0;
        }
    }
}
