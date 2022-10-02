using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
    [PacketHandler(206, "场景用户离开")]
	public class ChangeColorShellTimeOverHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			packet.ReadByte();
			packet.ReadInt();
			return 0;
        }
    }
}
