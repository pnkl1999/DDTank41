using Game.Base.Packets;
using Game.Logic.Phy.Object;

namespace Game.Logic.Cmd
{
    [GameCommand(138, "副武器")]
	public class SelectObjectCommand : ICommandHandler
    {
        public void HandleCommand(BaseGame game, Player player, GSPacketIn packet)
        {
			packet.ReadInt();
			packet.ReadInt();
        }
    }
}
