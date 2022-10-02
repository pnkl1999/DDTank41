using Game.Base.Packets;
using Game.Server.LittleGame.Objects;
using Game.Server.Packets;

namespace Game.Server.LittleGame.Handle
{
    [LittleGame(66)]
	public class CancelClick : ILittleGameCommandHandler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
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
					Player.Out.SendMessage(eMessageType.ChatNormal, "Oh yeah ... nó đã bị bắt.");
					return 0;
				}
				lock (bogu.Locker)
				{
					bogu.Catchers.Remove(Player);
					Player.LittleGameInfo.Bogu = null;
					if (Player.LittleGameInfo.Actions.Peek() == "livingInhale")
					{
						Player.LittleGameInfo.Actions.Clear();
					}
					Player.LittleGameInfo.Actions.Enqueue("livingUnInhale");
					if (bogu.Catchers.Count == 0)
					{
						bogu.Сaught = false;
						bogu.Action = "livingUnInhale";
					}
				}
				return 0;
			}
			if (Player.LittleGameInfo.Actions.Peek() == "livingInhale")
			{
				Player.LittleGameInfo.Actions.Clear();
			}
			Player.LittleGameInfo.Actions.Enqueue("livingUnInhale");
			//Player.Out.SendMessage(eMessageType.ChatNormal, "哎呀呀呀......它竟然溜走了.");
			return 0;
        }
    }
}
