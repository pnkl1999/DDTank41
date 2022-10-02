using Game.Base.Packets;
using Game.Server.GameUtils;

namespace Game.Server.Packets.Client
{
    [PacketHandler(30, "打开物品")]
	public class LotteryGetItem : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			int num = packet.ReadByte();
			packet.ReadInt();
			PlayerInventory caddyBag = client.Player.CaddyBag;
			PlayerInventory propBag = client.Player.PropBag;
			for (int i = 0; i < caddyBag.Capalility; i++)
			{
				caddyBag.GetItemAt(i);
			}
			return 1;
        }
    }
}
