using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
    [PacketHandler(245, "场景用户离开")]
	public class RequestAwardsHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			packet.ReadInt();
			packet.ReadInt();
			return 0;
        }
    }
}
