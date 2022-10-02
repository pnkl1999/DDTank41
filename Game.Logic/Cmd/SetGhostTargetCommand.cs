using Game.Base.Packets;
using Game.Logic.Phy.Object;

namespace Game.Logic.Cmd
{
    [GameCommand(54, "设置鬼魂目标")]
	public class SetGhostTargetCommand : ICommandHandler
    {
        public void HandleCommand(BaseGame game, Player player, GSPacketIn packet)
        {
			if (!player.IsLiving)
			{
				player.TargetPoint.X = packet.ReadInt();
				player.TargetPoint.Y = packet.ReadInt();
			}
        }
    }
}
