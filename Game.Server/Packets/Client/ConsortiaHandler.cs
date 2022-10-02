using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
    [PacketHandler(129, "公会聊天")]
	public class ConsortiaHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			if (client.Player.Consortia != null)
			{
				client.Player.Consortia.ProcessData(client.Player, packet);
			}
			return 0;
        }
    }
}
