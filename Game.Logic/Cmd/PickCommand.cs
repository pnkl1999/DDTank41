using Game.Base.Packets;
using Game.Logic.Phy.Object;

namespace Game.Logic.Cmd
{
    [GameCommand(49, "战斗中拾取箱子")]
	public class PickCommand : ICommandHandler
    {
        public void HandleCommand(BaseGame game, Player player, GSPacketIn packet)
        {
			player.OpenBox(packet.ReadInt());
        }
    }
}
