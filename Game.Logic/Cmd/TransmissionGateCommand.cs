using Game.Base.Packets;
using Game.Logic.Phy.Object;

namespace Game.Logic.Cmd
{
    [GameCommand(137, "Transmission Gate")]
	public class TransmissionGateCommand : ICommandHandler
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
