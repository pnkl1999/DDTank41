using Game.Base.Packets;
using Game.Logic.Phy.Object;

namespace Game.Logic.Cmd
{
    [GameCommand(17, "自杀")]
	public class SuicideCommand : ICommandHandler
    {
        public void HandleCommand(BaseGame game, Player player, GSPacketIn packet)
        {
			if (player.IsLiving && game.GameState == eGameState.Playing)
			{
				packet.Parameter1 = player.Id;
				game.SendToAll(packet);
				player.Die();
				game.CheckState(0);
			}
        }
    }
}
