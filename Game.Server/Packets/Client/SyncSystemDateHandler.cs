using Game.Base.Packets;
using System;

namespace Game.Server.Packets.Client
{
    [PacketHandler(5, "同步系统数据")]
	public class SyncSystemDateHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			packet.ClearContext();
			packet.WriteDateTime(DateTime.Now);
			client.Out.SendTCP(packet);
			return 0;
        }
    }
}
