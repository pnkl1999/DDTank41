using Game.Base.Packets;
using Game.Logic.Phy.Object;

namespace Game.Logic.Cmd
{
    [GameCommand(96, "准备开炮")]
	public class FireTagCommand : ICommandHandler
    {
        public void HandleCommand(BaseGame game, Player player, GSPacketIn packet)
        {
			if (player.IsAttacking)
			{
				packet.Parameter1 = player.Id;
				game.SendToAll(packet);
				game.SendSyncLifeTime();
				if (packet.ReadBoolean())
				{
					byte speedTime = packet.ReadByte();
					player.PrepareShoot(speedTime);
				}
			}
        }
    }
}
