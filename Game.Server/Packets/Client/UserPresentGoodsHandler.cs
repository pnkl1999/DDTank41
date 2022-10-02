using Game.Base.Packets;
using System.Text;

namespace Game.Server.Packets.Client
{
    [PacketHandler(57, "购买物品")]
	public class UserPresentGoodsHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			new StringBuilder();
			packet.ReadString();
			packet.ReadString();
			packet.ReadInt();
			client.Player.SendMessage("Tính năng này tạm khóa vui lòng liên hệ ADM.");
			return 0;
        }
    }
}
