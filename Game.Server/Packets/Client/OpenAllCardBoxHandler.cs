using Game.Base.Packets;
using Game.Server.GameUtils;
using SqlDataProvider.Data;
using System;

namespace Game.Server.Packets.Client
{
    [PacketHandler(204, "打开物品")]
	public class OpenAllCardBoxHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			PlayerInventory caddyBag = client.Player.CaddyBag;
			CardInventory cardBag = client.Player.CardBag;
			int num = 0;
			for (int i = 0; i < caddyBag.Capalility; i++)
			{
				ItemInfo itemAt = caddyBag.GetItemAt(i);
				if (itemAt != null)
				{
					caddyBag.RemoveItem(itemAt);
					Random random = new Random();
					int property = itemAt.Template.Property5;
					num = random.Next(1, 3);
					cardBag.AddCard(property, num);
					client.Player.SendMessage("Bạn vừa mở " + itemAt.Template.Name + " và nhận được " + num + " thẻ bài.");
				}
			}
			return 1;
        }
    }
}
