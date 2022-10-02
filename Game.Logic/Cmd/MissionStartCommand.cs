using Game.Base.Packets;
using Game.Logic.Phy.Object;

namespace Game.Logic.Cmd
{
    public class MissionStartCommand : ICommandHandler
    {
        public void HandleCommand(BaseGame game, Player player, GSPacketIn packet)
        {
			if ((game.GameState == eGameState.SessionPrepared || game.GameState == eGameState.GameOver) && packet.ReadBoolean())
			{
				player.Ready = true;
				game.CheckState(0);
			}
        }
    }
}
