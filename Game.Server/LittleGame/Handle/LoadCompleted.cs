using Game.Base.Packets;

namespace Game.Server.LittleGame.Handle
{
    [LittleGame(3)]
	public class LoadCompleted : ILittleGameCommandHandler
    {
        public int CommandHandler(GamePlayer Player, GSPacketIn packet)
        {
			LittleGameWorldMgr.Out.SendLoadComplete(Player, LittleGameWorldMgr.ScenariObjects);
			return 0;
        }
    }
}
