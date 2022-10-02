using Bussiness;
using Game.Base.Packets;
using Game.Server.GameUtils;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
    [PacketHandler(232, "打开物品")]
	public class CaddyClearAllHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			PlayerInventory caddyBag = client.Player.CaddyBag;
			int num = 1;
			int num2 = 0;
			int num3 = 0;
			string str = "";
			string str2 = "";
			for (int i = 0; i < caddyBag.Capalility; i++)
			{
				ItemInfo itemAt = caddyBag.GetItemAt(i);
				if (itemAt != null)
				{
					if (itemAt.Template.ReclaimType == 1)
					{
						num2 += num * itemAt.Template.ReclaimValue;
					}
					if (itemAt.Template.ReclaimType == 2)
					{
						num3 += num * itemAt.Template.ReclaimValue;
					}
					caddyBag.RemoveItem(itemAt);
				}
			}
			if (num2 > 0)
			{
				str = LanguageMgr.GetTranslation("Bạn nhận được {0} vàng", num2);
			}
			if (num3 > 0)
			{
				str2 = LanguageMgr.GetTranslation("Bạn nhận được {0} lễ kim", num3);
			}
			client.Player.BeginChanges();
			client.Player.AddGold(num2);
			client.Player.AddGiftToken(num3);
			client.Player.CommitChanges();
			client.Out.SendMessage(eMessageType.GM_NOTICE, str + " " + str2);
			return 1;
        }
    }
}
