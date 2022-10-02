using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
    [PacketHandler(165, "场景用户离开")]
	public class LuckStoneEnableHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			client.Player.UpdateProperties();
			return 0;
        }
    }
}
