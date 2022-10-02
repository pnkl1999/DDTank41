using Game.Base.Packets;

namespace Game.Server.Packets.Client
{
    [PacketHandler(169, "礼堂数据")]
	public class HotSpringRoomPlayerRemoveHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			if (client.Player.CurrentHotSpringRoom != null)
			{
				client.Player.CurrentHotSpringRoom.RemovePlayer(client.Player);
				GSPacketIn gSPacketIn = new GSPacketIn(169);
				gSPacketIn.WriteString($"Đã thoát khỏi suối nước nóng!");
				client.SendTCP(gSPacketIn);
			}
			return 0;
        }
    }
}
