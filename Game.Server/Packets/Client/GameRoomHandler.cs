using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
    [PacketHandler(94, "游戏创建")]
	public class GameRoomHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			if (client.Player.GameRoom != null)
			{
				client.Player.GameRoom.ProcessData(client.Player, packet);
			}
			return 0;
        }
    }
}
