using Game.Base.Packets;

namespace Game.Server.LittleGame.Handle
{
    [LittleGame(2)]
	public class EnterWorld : ILittleGameCommandHandler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
            if (Player.PlayerCharacter.Grade < 20)
            {
                Player.SendMessage(eMessageType.ALERT, "Bạn cần đạt level 20 mới có thể vào.");
                return 0;
            }
            else if (!LittleGameWorldMgr.IsOpen)
            {
                Player.SendMessage(eMessageType.ALERT, "Sự kiện chưa mở.");
                return 0;
            }
            LittleGameWorldMgr.AddPlayer(Player);
			return 0;
        }
    }
}
