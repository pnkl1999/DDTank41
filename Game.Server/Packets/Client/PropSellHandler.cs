using Bussiness.Managers;
using Game.Base.Packets;
using SqlDataProvider.Data;

namespace Game.Server.Packets.Client
{
    [PacketHandler(55, "出售道具")]
	public class PropSellHandler : IPacketHandler
    {
        public int HandlePacket(GameClient client, GSPacketIn packet)
        {
			int gold = 0;
			int money = 0;
			int offer = 0;
			int gifttoken = 0;
			int medal = 0;
			int damageScore = 0;
			int petScore = 0;
			int iTemplateID = 0;
			int iCount = 0;
			int hardCurrency = 0;
			int LeagueMoney = 0;
			int honor = 0;
			int type = 1;
			int slot = packet.ReadInt();
			int iD = packet.ReadInt();
			ItemInfo itemAt = client.Player.FightBag.GetItemAt(slot);
			if (itemAt != null)
			{
				client.Player.FightBag.RemoveItem(itemAt);
				ShopMgr.SetItemType(ShopMgr.GetShopItemInfoById(iD), type, ref damageScore, ref petScore, ref iTemplateID, ref iCount, ref gold, ref money, ref offer, ref gifttoken, ref medal, ref hardCurrency, ref LeagueMoney, ref medal, ref honor);
				client.Player.AddGold(gold);
			}
			return 0;
        }
    }
}
