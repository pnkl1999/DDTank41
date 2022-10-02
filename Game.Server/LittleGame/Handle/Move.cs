using Game.Base.Packets;

namespace Game.Server.LittleGame.Handle
{
    [LittleGame(32)]
	public class Move : ILittleGameCommandHandler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			int num = packet.ReadInt();
			int num2 = packet.ReadInt();
			int x = packet.ReadInt();
			int y = packet.ReadInt();
			int num3 = packet.ReadInt();
			Player.LittleGameInfo.X = x;
			Player.LittleGameInfo.Y = y;
			LittleGameWorldMgr.Out.SendMoveToAll(Player);
			return 0;
        }
    }
}
