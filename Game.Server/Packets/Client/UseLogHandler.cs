using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
    [PacketHandler(213, "场景用户离开")]
	public class UseLogHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			int code = packet.ReadInt();
			return 0;
        }
    }
}
