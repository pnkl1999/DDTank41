using Game.Base.Packets;
using Game.Logic.Phy.Object;

namespace Game.Logic.Cmd
{
    [GameCommand(7, "改变方向")]
	public class DirectionCommand : ICommandHandler
    {
        public void HandleCommand(BaseGame game, Player player, GSPacketIn packet)
        {
			player.Direction = packet.ReadInt();
			game.SendLivingUpdateDirection(player);
        }
    }
}
