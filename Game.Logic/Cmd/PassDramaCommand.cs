using Game.Base.Packets;
using Game.Logic.Phy.Object;

namespace Game.Logic.Cmd
{
    [GameCommand(133, "跳过剧情动画")]
	public class PassDramaCommand : ICommandHandler
    {
        public void HandleCommand(BaseGame game, Player player, GSPacketIn packet)
        {
			if (game is PVEGame && game.GameState != eGameState.Playing)
			{
				PVEGame obj = game as PVEGame;
				obj.IsPassDrama = packet.ReadBoolean();
				obj.CheckState(0);
			}
        }
    }
}
