using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
    [PacketHandler(81, "游戏创建")]
	public class FarmHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			if (client.Player.FarmHandler != null)
			{
				client.Player.FarmHandler.ProcessData(client.Player, packet);
			}
			return 1;
        }
    }
}
