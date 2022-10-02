using Game.Base.Packets;

namespace Game.Server.LittleGame.Handle
{
    [LittleGame(33)]
	public class PosSync : ILittleGameCommandHandler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			int num = packet.ReadInt();
			int num2 = packet.ReadInt();
			return 0;
        }
    }
}
