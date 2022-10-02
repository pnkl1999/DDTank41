using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
    [PacketHandler(64, "场景用户离开")]
	public class OptionHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			packet.ReadInt();
			return 0;
        }
    }
}
