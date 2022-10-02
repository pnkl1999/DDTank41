using Game.Base.Packets;

namespace Game.Server.LittleGame.Handle
{
    [LittleGame(4)]
	internal class LeaveWorld : ILittleGameCommandHandler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			LittleGameWorldMgr.RemovePlayer(Player);
			return 0;
        }
    }
}
